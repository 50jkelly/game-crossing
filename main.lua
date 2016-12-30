viewport = require "viewport"
player = require "player"
layers = require "layer"
items = require "items"

-- Controls
controls = {}
controls["up"] = "w"
controls["down"] = "s"
controls["left"] = "a"
controls["right"] = "d"

function love.load()
	player.load()

	treeTop = love.graphics.newImage("images/tree_1_top.png")
	treeBottom = love.graphics.newImage("images/tree_1_bottom.png")

	-- Test trees
	tree1 = items.new(100, 100, 182, 200)
	tree1 = items.addPart(tree1, {height=160, layer=2, sprite=treeTop})
	tree1 = items.addPart(tree1, {y = tree1["y"] + 160, height=40, layer=1, sprite=treeBottom})

	tree2 = items.new(300, 100, 182, 200)
	tree2 = items.addPart(tree2, {height=160, layer=2, sprite=treeTop})
	tree2 = items.addPart(tree2, {y = tree2["y"] + 160, height=40, layer=1, sprite=treeBottom})

	-- Add items to the drawing layers
	layers.addItem(tree1)
	layers.addItem(tree2)
end

function love.update(dt)
	viewport.update(dt, player["direction"], player.speed)
	player.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(140, 225, 120)

	-- Draw layers behind the player
	layers.draw(1, viewport)

	-- Draw the player
	player.draw(viewport)

	-- Draw layers in front of the player
	layers.draw(2, viewport)
end
