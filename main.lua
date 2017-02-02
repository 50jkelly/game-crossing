function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	-- Events
	signal = require 'libraries.hump.signal'

	-- Controls
	controls = load_file('data/movement.lua')

	-- Game state
	game_state_machine = (require 'state_machines.game').new(controls, signal)

	-- Delta time
	dt = nil

	-- In game time
	time = { years=0, months=0, days=0, hours=12, minutes=0, seconds=0, minutes_today=0 }

	-- Graphics
	graphics = {}
	for _, row in ipairs(load_file('data/graphics.lua')) do
		graphics[row.category..'_'..row.name] = graphics[row.category..'_'..row.name] or {}
		graphics[row.category..'_'..row.name] = love.graphics.newImage(row.path)
	end

	-- Objects
	objects, to_draw = {{}, {}, {}}, {{}, {}, {}}
	colliders = {}
	for _, row in ipairs(load_file('data/objects.lua')) do
		local object = {}
		for index, value in pairs(row) do object[index] = value end
		object.light_map = graphics['light_maps_'..row.light_map]
		object.light_mask = graphics['light_masks_'..row.light_mask]
		object.sprite = graphics['sprites_'..row.name..'_'..row.state..'_1']
		table.insert(objects[row.layer], object)

		if object.collides then
			colliders[object.scene] = colliders[object.scene] or {}
			table.insert(colliders[object.scene], object)
		end
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

	-- Keyboard
	keyboard_state_machines = {}
	for key, _ in pairs(controls) do
		keyboard_state_machines[key] = (require 'state_machines.key').new(key, signal)
	end

	-- Player
	player_movement_state_machine = (require 'state_machines.movement').new(player, signal)
	player_animation_state_machine = (require 'state_machines.animation').new(player, signal)
	player_collision_state_machine = (require 'state_machines.collision').new(player, signal)
end

function love.update(_dt)
	-- FPS
	love.window.setTitle('FPS: '..love.timer.getFPS())

	-- Delta time
	dt = _dt

	-- Keyboard input
	for key, machine in pairs(keyboard_state_machines) do
		if machine.current == 'keydown' then
			if controls[key][game_state_machine.current] and controls[key][game_state_machine.current].on == 'keydown' then
				signal.emit(controls[key][game_state_machine.current].action, key)
			end
		end
	end

	if game_state_machine.current == 'game' then
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
		-- Collisions
		signal.emit('checkcollision', {
			objects = objects,
			layer_index = 2,
			object_index = 1,
			dt = dt
		})
	end

	-- Day night cycle
	ambient_color = ambient_colors[time.minutes_today] or ambient_color

	-- Loop
	for layer_index, layer in ipairs(objects) do for object_index, object in ipairs(layer) do
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
			if object.sprite then
				love.graphics.draw(object.sprite, object.x, object.y)
			end
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
	signal.emit('keyboard_pressed', {key=key})
end

function love.keyreleased(key)
	signal.emit('keyboard_released', {key=key})
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
