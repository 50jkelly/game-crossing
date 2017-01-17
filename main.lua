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
	persistence = require 'engine.persistence',
	viewport = require 'engine.viewport',
	sprites = require 'engine.sprites',
	renderer = require 'engine.renderer',
	controls = require 'engine.controls',
	collision = require "engine.collision",
	animation = require 'engine.animation',
	things = require 'engine.things',
	triggers = require 'engine.triggers',
	messageBox = require 'engine.messageBox',
	inventory = require 'engine.inventory',
	actionBar = require 'engine.actionBar',
	player = require 'player',
	items = require 'items',
	trees = require 'trees',
	plants = require 'plants'
}

function love.load()
	callHook('plugins', 'initialise')
	callHook('plugins', 'loadGraphics')
	callHook('plugins', 'assetsLoaded')
end

function love.update(dt)
	callHook('plugins', 'update', dt)
end

function love.draw()
	love.graphics.setBackgroundColor(140, 225, 120)
	callHook('plugins', 'preDraw')
	callHook('plugins', 'draw')
	callHook('plugins', 'postDraw')
	callHook('plugins', 'drawUI')
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
	return not (rect1.x + rect1.width + m < rect2.x
		or rect2.x + rect2.width + m < rect1.x
		or rect1.y + rect1.height + m < rect2.y
		or rect2.y + rect2.height + m < rect1.y)
end
