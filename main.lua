viewport = require "viewport"
player = require "player"
layers = require "layer"

-- Controls
controls = {}
controls["up"] = "w"
controls["down"] = "s"
controls["left"] = "a"
controls["right"] = "d"

-- Test trees
tree1 = {}
tree1["x"] = 100
tree1["y"] = 100
function tree1.draw()
	love.graphics.draw(tree1["sprite"], tree1["x"], tree1["y"], 0, 0.2, 0.2, 0, 0)
end

tree2 = {}
tree2["x"] = 300
tree2["y"] = 100
function tree2.draw()
	love.graphics.draw(tree2["sprite"], tree2["x"], tree2["y"], 0, 0.2, 0.2, 0, 0)
end

-- Add items to the drawing layers
layers.addItem(1, tree1)
layers.addItem(2, tree2)

function love.load()
	player.load()
	tree1["sprite"] = love.graphics.newImage("images/test_tree_1.png")
	tree2["sprite"] = love.graphics.newImage("images/test_tree_1.png")
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
