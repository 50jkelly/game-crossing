function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	-- Game state
	state = 'game'
	-- In game time
	time = {days = 0, hours = 12, minutes = 0, seconds = 0}
	-- Graphics
	sprites, light_maps, light_masks = {}, {}, {}
	sprites.grass = love.graphics.newImage('images/grass.png')
	sprites.tree_1_bottom = love.graphics.newImage('images/trees/tree_1_bottom.png')
	sprites.tree_1_top = love.graphics.newImage('images/trees/tree_1_top.png')
	player_sprites = {up = {}, down = {}, left = {}, right = {}}
	for state, _ in pairs(player_sprites) do for i=1, 8, 1 do
		table.insert(player_sprites[state], love.graphics.newImage('images/player_walk_'..state..'_'..i..'.png'))
	end end
	light_maps.player = love.graphics.newImage('images/light_maps/player_light.png')
	light_masks.tree_1_top = love.graphics.newImage('images/light_masks/tree_1_light_mask.png')
	-- Objects
	objects, to_draw = {{}, {}, {}}, {{}, {}, {}}
	-- Grass
	for x=-5000, 5000, 320 do for y=-5000, 5000, 320 do
		table.insert(objects[1], { sprite = sprites.grass, x = x, y = y, width = 320, height = 320, scene = 1, })
	end end
	-- Player
	table.insert(objects[2], {sprite = player_sprites['down'][1], light_map = light_maps.player, state = 'down', animating = false, fps = 10, frame = 1, x = 0, y = 0, width = 20, height = 26, speed = 100, scene = 1, collides = true, })
	player = objects[2][1]
	-- Trees
	table.insert(objects[2], { sprite = sprites.tree_1_bottom, x = 100, y = 100, width = 30, height = 30, scene = 1, collides = true, })
	table.insert(objects[3], { sprite = sprites.tree_1_top, light_mask = light_masks.tree_1_top, x = 40, y = -80, width = 150, height = 191, scene = 1, collides = false, })
	-- Viewport
	love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	-- Scene
	current_scene = 1
	-- Shaders
	light_shader = love.graphics.newShader([[
	extern Image light_map;
	extern Image light_mask;
	extern vec4 ambient_color;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixel_color = Texel(texture, texture_coords);
		vec4 light_color = Texel(light_map, texture_coords);
		vec4 light_mask_color = Texel(light_mask, texture_coords);
		vec4 result = (light_color * light_mask_color + ambient_color) * pixel_color;
		return min(pixel_color, result);}]])
end

function love.update(dt)
	-- FPS
	love.window.setTitle('FPS: '..love.timer.getFPS())
	if state == 'game' then
		-- In game time
		time_elapsed = (time_elapsed or 0) + dt
		while time_elapsed > 1 / 20000 do
			time.seconds = time.seconds + 1
			time_elapsed = time_elapsed - 1 / 20000
		end
		increment_time('minutes', 'seconds', 60)
		increment_time('hours', 'minutes', 60)
		increment_time('days', 'hours', 24)
		time.total_minutes = (time.days * 24 + time.hours) * 60 + time.minutes
		time.minutes_today = time.hours * 60 + time.minutes
		-- Viewport
		viewport.x = (player.x + player.width / 2) - viewport.width / 2
		viewport.y = (player.y + player.height / 2) - viewport.height / 2
		-- Animation
		animation_time_elapsed = (animation_time_elapsed or 0) + dt
		while animation_time_elapsed > 1 / player.fps do
			if player.animating then
				player.frame = math.max(1, (player.frame + 1) % 9)
			end
			animation_time_elapsed = animation_time_elapsed - 1 / player.fps
			player.sprite = player_sprites[player.state][player.frame]
		end
		-- Movement
		player.old_x = player.x
		player.old_y = player.y
		if keydown == 'w' then player.y = player.y - player.speed * dt end
		if keydown == 's' then player.y = player.y + player.speed * dt end
		if keydown == 'a' then player.x = player.x - player.speed * dt end
		if keydown == 'd' then player.x = player.x + player.speed * dt end
		player_states = { w = 'up', s = 'down', a = 'left', d = 'right' }
		if player_states[keydown] then
			player.state = player_states[keydown] or player.state
			player.animating = true
		else
			player.animating = false
			player.frame = 1
		end
	end
	-- Day night cycle
	time.sunrise = {time = 6 * 60, duration = 2 * 60}
	time.sunset = {time = 20 * 60, duration = 2 * 60}
	day_color, night_color = {1, 1, 1, 0}, {.3, .3, .7, 0}
	ambient_color = calculate_transition_color((time.minutes_today or 0), time.sunrise.time, time.sunrise.duration, night_color, day_color) or
		calculate_transition_color((time.minutes_today or 0), time.sunset.time, time.sunset.duration, day_color, night_color) or
		calculate_default_color((time.minutes_today or 0), time.sunrise.time, time.sunset.time, day_color, night_color)
	-- Loop
	for layer_index, layer in ipairs(objects) do for object_index, object in ipairs(layer) do
		if state == 'game' then
			-- Collisions
			player.collision = player.collision or function()
				player.x = player.old_x
				player.y = player.old_y
			end
			for li, l in ipairs(objects) do for oi, o in ipairs(l) do
				if (li ~= layer_index or oi ~= object_index) and object.collides and o.collides and overlapping(object, o) and object.collision then
					object.collision(o)
				end
			end end
		end
		-- Select objects to draw
		if object.scene == current_scene and overlapping(object, viewport) then
			table.insert(to_draw[layer_index], object)
		end
	end end
end

function love.draw()
	-- Initialise canvases
	clear_canvas(light_map, {0,0,0,255})
	clear_canvas(light_mask, {255,255,255,255})
	-- Viewport
	love.graphics.push()
	love.graphics.translate(-viewport.x, -viewport.y)
	-- Objects
	for layer_index, layer in ipairs(to_draw) do 
		table.sort(layer, function(a, b) return a.y < b.y end)
		for _, object in ipairs(layer) do
			love.graphics.setCanvas(diffuse_canvas)
			love.graphics.draw(object.sprite, object.x, object.y)
			if object.light_map then
				love.graphics.setCanvas(light_map)
				local light_width, light_height = object.light_map:getDimensions()
				local x = (object.x + object.width / 2) - (light_width / 2)
				local y = (object.y + object.height / 2) - (light_height / 2)
				love.graphics.draw(object.light_map, x, y)
			end
			if object.light_mask then
				love.graphics.setCanvas(light_mask)
				love.graphics.draw(object.light_mask, object.x, object.y)
			end
		end
		to_draw[layer_index] = {}
	end
	love.graphics.pop()
	love.graphics.setCanvas()
	light_shader:send('ambient_color', ambient_color)
	light_shader:send('light_map', light_map)
	light_shader:send('light_mask', light_mask)
	love.graphics.setShader(light_shader)
	love.graphics.draw(diffuse_canvas, 0, 0)
	love.graphics.setShader()
end

function love.keypressed(key)
	keydown = key
end

function love.keyreleased(key)
	if keydown == key then keydown = nil end
end

function love.resize(width, height)
	viewport = {x = 0, y = 0, width = width, height = height}
	diffuse_canvas, light_map, light_mask = love.graphics.newCanvas(width, height), love.graphics.newCanvas(width, height), love.graphics.newCanvas(width, height) 
end

function overlapping(r1, r2)
	return not (r1.x + r1.width < r2.x or r2.x + r2.width < r1.x or r1.y + r1.height < r2.y or r2.y + r2.height < r1.y)
end

function increment_time(bigger, smaller, max)
	if time[smaller] >= max then
		time[bigger] = time[bigger] + 1
		time[smaller] = time[smaller] - max
	end
end

function calculate_transition_color(minutes, transition, duration, start_color, target_color)
	local result_color = {}
	for i, _ in ipairs(target_color) do
		local transition_progress = minutes - transition
		if transition_progress < 0 then return nil end
		if transition_progress > duration then return nil end
		result_color[i] = start_color[i] + (target_color[i] - start_color[i]) * (transition_progress / duration)
	end
	return result_color
end

function calculate_default_color(minutes, sunrise, sunset, day_color, night_color)
	if minutes > sunrise and minutes < sunset then return day_color end
	return night_color
end

function clear_canvas(canvas, color)
	local width, height = canvas:getDimensions()
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', 0, 0, width, height)
end
