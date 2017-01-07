-- Data
data = {
	screenWidth = 800,
	screenHeight = 600,
	items = {},
	drawWorldPosition = true
}

-- Plugins
data.plugins = {
	viewport = require "viewport",
	renderer = require "renderer",
	controls = require "controls",
	collision = require "collision",
	animation = require "animation",
	player = require "player",
	messageBox = require "messageBox",
	trees = require "trees"
}

-- Items
data.items = {}

function love.load()
	callHook('plugins', 'initialise')
	callHook('items', 'initialise')
	callHook('plugins', 'loadGraphics')
	callHook('items', 'loadGraphics')
end

function love.update(dt)
	data.dt = dt
	callHook('plugins', 'update')
	callHook('items', 'update')
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
