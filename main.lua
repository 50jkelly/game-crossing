function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	-- Events
	signal = require 'libraries.hump.signal'
	-- Game state
	state = 'game'
	-- In game time
	time = { years=0, months=0, days=0, hours=12, minutes=0, seconds=0, minutes_today=0 }
	-- Graphics
	graphics = {}
	for _, row in ipairs(load_file('data/graphics.lua')) do
		graphics[row.category..row.name..row.state] = graphics[row.category..row.name..row.state] or {}
		graphics[row.category..row.name..row.state][row.frame] = love.graphics.newImage(row.path)
	end
	-- Objects
	objects, to_draw = {{}, {}, {}}, {{}, {}, {}}
	for _, row in ipairs(load_file('data/objects.lua')) do
		local object = {}
		for index, value in pairs(row) do object[index] = value end
		object.light_map = graphics['light_maps'..row.light_map..row.light_map_state][1]
		object.light_mask = graphics['light_masks'..row.light_mask..row.light_mask_state][1]
		object.sprite = graphics['sprites'..row.name..row.state][1]
		table.insert(objects[row.layer], object)
	end
	player = objects[2][1]
	-- Viewport
	love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	-- Scene
	current_scene = 1
	-- Day/night cycle
	ambient_colors = load_file('data/ambient_colors.lua')
	-- Shaders
	light_shader = love.graphics.newShader(load_file('data/light_shader.lua'))
	-- Helpers
	helpers = {}
	helpers.player = require 'helpers.player'
	helpers.player.initialise(player, signal)
	-- Keyboard
	keyboard = (require 'state_machines.keyboard').new({}, signal)
	controls = load_file('data/movement.lua')
end

function love.update(dt)
	-- FPS
	love.window.setTitle('FPS: '..love.timer.getFPS())
	if state == 'game' then
		-- In game time
		time_elapsed = (time_elapsed or 0) + dt
		while time_elapsed > 1 / 5000 do
			time.seconds = time.seconds + 1
			time_elapsed = time_elapsed - 1 / 5000
		end
		increment_time('minutes', 'seconds', 60)
		increment_time('hours', 'minutes', 60)
		increment_time('days', 'hours', 24)
		increment_time('months', 'days', 7)
		increment_time('years', 'months', 12)
		time.minutes_today = math.min(24 * 60, time.hours * 60 + time.minutes)
		-- Viewport
		viewport.x = (player.x + player.width / 2) - viewport.width / 2
		viewport.y = (player.y + player.height / 2) - viewport.height / 2
		-- Movement
		signal.emit('checkkeys', { controls = controls, dt = dt })
	end
	-- Day night cycle
	ambient_color = ambient_colors[time.minutes_today] or ambient_color
	-- Loop
	for layer_index, layer in ipairs(objects) do for object_index, object in ipairs(layer) do
		if state == 'game' then
			-- Animation
			if object.fps ~= 'none' then
				animation_time_elapsed = (animation_time_elapsed or 0) + dt
				while animation_time_elapsed > 1 / object.fps do
					object.frame = object.frame or 1
					if object.animating then
						object.frame = math.max(1, (object.frame + 1) % 9)
					end
					animation_time_elapsed = animation_time_elapsed - 1 / object.fps
					object.sprite = graphics['sprites'..object.name..object.state][object.frame]
				end
			end
			-- Collisions
			helpers.player.collision(object, layer_index, object_index)
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
	signal.emit('keypressed', {key = key})
end

function love.keyreleased(key)
	signal.emit('keyreleased', {key = key})
end

function love.resize(width, height)
	viewport = {x = 0, y = 0, width = width, height = height}
	diffuse_canvas, light_map, light_mask = love.graphics.newCanvas(width, height), love.graphics.newCanvas(width, height), love.graphics.newCanvas(width, height) 
end

function overlapping(r1, r2)
	return not (r1.x + r1.width < r2.x or r2.x + r2.width < r1.x or r1.y + r1.height < r2.y or r2.y + r2.height < r1.y)
end

function increment_time(bigger, smaller, max)
	while time[smaller] >= max do
		time[bigger] = time[bigger] + 1
		time[smaller] = time[smaller] - max
	end
end

function clear_canvas(canvas, color)
	local width, height = canvas:getDimensions()
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', 0, 0, width, height)
end

function load_file(path)
	local file = io.open(path, 'r')
	io.input(file)
	local contents = loadstring(io.read('*all'))()
	io.close(file)
	return contents
end

function save_file(data, path)
	local file = io.open(path, 'w')
	local serpent = require 'libraries.serpent'
	io.output(file)
	io.write(serpent.block(data, {name='data'}))
	io.close(file)
end
