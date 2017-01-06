-- Data
local data = {
	screenWidth = 800,
	screenHeight = 600,
	items = {},
	drawWorldPosition = true
}

-- Controls
data.controls = {
	up = "w",
	down = "s",
	left= "a",
	right = "d"
}

-- Plugins
data.plugins = {
	viewport = require "viewport",
	player = require "player",
	trees = require "trees"
}

-- Items
data.items = {}

function love.load()
	for _, plugin in pairs(data.plugins) do
		if plugin.load ~= nil then
			data = plugin.load(data)
		end
	end

	for _, item in ipairs(data.items) do
		if item.load ~= nil then
			data = item.load(data)
		end
	end
end

function love.update(dt)
	data.dt = dt

	for _, plugin in pairs(data.plugins) do
		if plugin.update ~= nil then
			data = plugin.update(data)
		end
	end

	for _, item in ipairs(data.items) do
		if item.update ~= nil then
			data = item.update(data)
		end
	end
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(-data.plugins.viewport.x, -data.plugins.viewport.y)

	-- Set background colour
	love.graphics.setBackgroundColor(140, 225, 120)

	-- We need to sort the items ordered by their worldY value ascending
	table.sort(data.items, function(a, b)
		return a.y < b.y
	end)

	-- Draw all items
	for _, item in ipairs(data.items) do
		love.graphics.draw(item.sprite, item.x + item.drawXOffset, item.y + item.drawYOffset, 0, 1, 1, 0, 0)

		if data.drawWorldPosition then
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", item.x, item.y, item.width, item.height)
			love.graphics.setColor(255,255,255,255)
		end
	end

	love.graphics.pop()
end
