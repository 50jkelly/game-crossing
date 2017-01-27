-- Data
data = {
	state = 'game'
}

-- Plugins
data.plugins = {
	persistence = require 'engine.persistence',
	viewport = require 'engine.viewport',
	sprites = require 'engine.sprites',
	renderer = require 'engine.renderer',
	shaders = require 'engine.shaders',
	keyboard = require 'engine.keyboard',
	mouse = require 'engine.mouse',
	collision = require "engine.collision",
	animation = require 'engine.animation',
	things = require 'engine.things',
	inventory = require 'engine.inventory',
	actionBar = require 'engine.actionBar',
	fpsTitle = require 'engine.fpsTitle',
	clock = require 'engine.clock',

	constants = require 'scripts.constants',
	events = require 'scripts.events',
	items = require 'scripts.items',
	dayNightCycle = require 'scripts.dayNightCycle',
	dialogs = require 'scripts.dialogs',

	player = require 'scripts.player',
	grass = require 'scripts.grass',
	trees = require 'scripts.trees',
	flowers = require 'scripts.flowers',
	juvenileFlower = require 'scripts.juvenileFlower'
}

data.libraries = {
	vector = require 'libraries.hump.vector',
}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	callHook('plugins', 'initialise')
	callHook('plugins', 'load_graphics')
	callHook('plugins', 'assets_loaded')
end

function love.update(dt)
	callHook('plugins', 'update', dt)
end

function love.draw()
	callHook('plugins', 'pre_draw')
	callHook('plugins', 'draw')
	callHook('plugins', 'post_draw')
	callHook('plugins', 'draw_ui')
end

function love.resize(width, height)
	data.plugins.viewport.width = width
	data.plugins.viewport.height = height
	data.plugins.renderer.initialise()
end

function callHook(collection, method, hookData)
	for _, value in pairs(data[collection]) do
		if value[method] ~= nil then
			value[method](hookData)
		end
	end
end

function merge(table1, table2)
	local t = {}
	for i, v in pairs(table1) do
		t[i] = v
	end
	for i, v in pairs(table2) do
		t[i] = v
	end
	return t
end

function getNextFreeId(data, prefix)
	local id = 1
	while true do
		if not data[prefix..id] then
			return prefix..id
		end
		id = id + 1
	end
end

function overlapping(rect1, rect2, margin)
	local m = margin or 0
	if rect1.width and rect1.height and rect2.width and rect2.height then
		return not (rect1.x + rect1.width + m < rect2.x
			or rect2.x + rect2.width + m < rect1.x
			or rect1.y + rect1.height + m < rect2.y
			or rect2.y + rect2.height + m < rect1.y)
	end
end

function getDistance(point1, point2)
	local a = point2.x - point1.x
	local b = point2.y - point1.y
	return (a * a) + (b * b)
end

function getViewport()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local x = 0
	local y = 0

	if data.plugins.viewport then
		x = data.plugins.viewport.x
		y = data.plugins.viewport.y
	end

	return {
		width = width,
		height = height,
		x = x,
		y = y
	}
end

function copyThing(toCopy, x, y)
	new = {}

	for index, value in pairs(toCopy) do
		new[index] = value
	end

	if x then
		new.x = x 
	end

	if y then
		new.y = y 
	end

	return new
end
