viewport = require "viewport"
player = require "player"

-- Controls
controls = {}
controls["up"] = "w"
controls["down"] = "s"
controls["left"] = "a"
controls["right"] = "d"

-- Test tree
tree = {}
tree["x"] = 100
tree["y"] = 100

function love.load()
	player.load()
	tree["sprite"] = love.graphics.newImage("images/test_tree_1.png")
end

function love.update(dt)
	viewport.update(dt, player["direction"], player.speed)
	player.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(140, 225, 120)
	player.draw(viewport)

	love.graphics.push()
	love.graphics.translate(-viewport["x"], -viewport["y"])
	love.graphics.draw(tree["sprite"], tree["x"], tree["y"], 0, 0.3, 0.3, 0, 0)
	love.graphics.pop()
end
