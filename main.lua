viewport = require "viewport"
player = require "player"
layers = require "layer"
items = require "items"
trees = require "trees"

-- General game information
local screenWidth = 800
local screenHeight = 600
local drawWorldPosition = false

-- Controls
local controls = {}
controls.up = "w"
controls.down = "s"
controls.left= "a"
controls.right = "d"

-- Drawing items
items = {}

function love.load()
	viewport.load(0, 0, screenWidth, screenHeight)
	player.load()

	tree1Sprite = love.graphics.newImage("images/tree1.png")
	table.insert(items, player)

	-- Plant a forest
	for i=1, 200, 1 do
		local x = math.random(-1000, 1000)
		local y = math.random(-1000, 1000)
		table.insert(items, trees.new(x, y, tree1Sprite))
	end
end

function love.update(dt)
	viewport.update(player)
	player.update(dt, controls, items)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(-viewport.x, -viewport.y)

	-- Set background colour
	love.graphics.setBackgroundColor(140, 225, 120)

	-- We need to sort the items ordered by their worldY value ascending
	table.sort(items, function(a, b)
		return a.worldY < b.worldY
	end)

	-- Draw all items
	for _, item in ipairs(items) do
		love.graphics.draw(item.sprite, item.worldX + item.drawXOffset, item.worldY + item.drawYOffset, 0, 1, 1, 0, 0)

		if drawWorldPosition then
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", item.worldX, item.worldY, item.worldWidth, item.worldHeight)
			love.graphics.setColor(255,255,255,255)
		end
	end

	love.graphics.pop()
end
