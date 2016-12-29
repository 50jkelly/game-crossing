player = require "player"

-- Controls
controls = {}
controls["up"] = "w";
controls["down"] = "s";
controls["left"] = "a";
controls["right"] = "d";

function love.load()
	player.load()
end


function love.update()
	player.update(controls)
end

function love.draw()
	love.graphics.setBackgroundColor(140, 225, 120)
	player.draw()
end
