-- Data
local data = {
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
	player = require "player",
	trees = require "trees"
}

-- Items
data.items = {}

function love.load()
	callHook('plugins', 'load')
	callHook('items', 'load')
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

end

function callHook(collection, method)
	for _, value in pairs(data[collection]) do
		if value[method] ~= nil then
			data = value[method](data)
		end
	end
end
