-- Data
data = {
	screenWidth = 800,
	screenHeight = 600,
	staticEntities = {},
	dynamicEntities = {},
	state = 'game'
}

-- Plugins
data.plugins = {
	saveLoad = require 'saveLoad',
	viewport = require "viewport",
	sprites = require 'sprites',
	renderer = require "renderer",
	controls = require "controls",
	collision = require "collision",
	animation = require "animation",
	staticEntities = require 'staticEntities',
	player = require "player",
	triggers = require "triggers",
	messageBox = require "messageBox",
	inventory = require "inventory",
	actionBar = require 'actionBar',
	items = require "items",
	trees = require "trees"
}

function love.load()
	callHook('plugins', 'initialise')
	callHook('staticEntities', 'initialise')
	callHook('dynamicEntities', 'initialise')
	callHook('plugins', 'loadGraphics')
	callHook('staticEntities', 'loadGraphics')
	callHook('dynamicEntities', 'loadGraphics')
	callHook('plugins', 'assetsLoaded')
end

function love.update(dt)
	data.dt = dt
	callHook('plugins', 'update')
	callHook('staticEntities', 'update')
	callHook('dynamicEntities', 'update')
end

function love.draw()
	-- Set background colour
	love.graphics.setBackgroundColor(140, 225, 120)

	callHook('plugins', 'preDraw')
	callHook('plugins', 'draw')
	callHook('plugins', 'postDraw')
	callHook('plugins', 'drawUI')
end

function callHook(collection, method)
	for _, value in pairs(data[collection]) do
		if value[method] ~= nil then
			value[method]()
		end
	end
end

function overlapping(rect1, rect2)
	return not (rect1.x + rect1.width < rect2.x
		or rect2.x + rect2.width < rect1.x
		or rect1.y + rect1.height < rect2.y
		or rect2.y + rect2.height < rect1.y)
end

function concat(table1, table2)
	local t = {}
	for _, item in ipairs(table1) do
		table.insert(t, item)
	end
	for _, item in ipairs(table2) do
		table.insert(t, item)
	end
	return t
end
