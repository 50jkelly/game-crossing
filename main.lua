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
tree1["top"] = {}
tree1["bottom"] = {}
tree1["x"] = 100
tree1["y"] = 100
tree1["width"] = 182
tree1["height"] = 200
tree1["top"]["x"] = tree1["x"]
tree1["top"]["y"] = tree1["y"]
tree1["top"]["width"] = tree1["width"]
tree1["top"]["height"] = 160
tree1["top"]["layer"] = 2
tree1["bottom"]["x"] = tree1["x"]
tree1["bottom"]["y"] = tree1["y"] + tree1["top"]["height"]
tree1["bottom"]["width"] = tree1["width"]
tree1["bottom"]["height"] = 40
tree1["bottom"]["layer"] = 1

function tree1.top.draw()
	love.graphics.draw(tree1["top"]["sprite"], tree1["top"]["x"], tree1["top"]["y"], 0, 1, 1, 0, 0)
end

function tree1.bottom.draw()
	love.graphics.draw(tree1["bottom"]["sprite"], tree1["bottom"]["x"], tree1["bottom"]["y"], 0, 1, 1, 0, 0)
end

tree2 = {}
tree2["top"] = {}
tree2["bottom"] = {}
tree2["x"] = 300
tree2["y"] = 100
tree2["width"] = 182
tree2["height"] = 200
tree2["top"]["x"] = tree2["x"]
tree2["top"]["y"] = tree2["y"]
tree2["top"]["width"] = tree2["width"]
tree2["top"]["height"] = 160
tree2["top"]["layer"] = 2
tree2["bottom"]["x"] = tree2["x"]
tree2["bottom"]["y"] = tree2["y"] + tree2["top"]["height"]
tree2["bottom"]["width"] = tree2["width"]
tree2["bottom"]["height"] = 40
tree2["bottom"]["layer"] = 1

function tree2.top.draw()
	love.graphics.draw(tree2["top"]["sprite"], tree2["top"]["x"], tree2["top"]["y"], 0, 1, 1, 0, 0)
end

function tree2.bottom.draw()
	love.graphics.draw(tree2["bottom"]["sprite"], tree2["bottom"]["x"], tree2["bottom"]["y"], 0, 1, 1, 0, 0)
end

-- Add items to the drawing layers
layers.addItem(tree1["top"]["layer"], tree1["top"])
layers.addItem(tree1["bottom"]["layer"], tree1["bottom"])
layers.addItem(tree2["top"]["layer"], tree2["top"])
layers.addItem(tree2["bottom"]["layer"], tree2["bottom"])

function love.load()
	player.load()
	tree1["top"]["sprite"] = love.graphics.newImage("images/tree_1_top.png")
	tree1["bottom"]["sprite"] = love.graphics.newImage("images/tree_1_bottom.png")
	tree2["top"]["sprite"] = love.graphics.newImage("images/tree_1_top.png")
	tree2["bottom"]["sprite"] = love.graphics.newImage("images/tree_1_bottom.png")
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
