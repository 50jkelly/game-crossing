animation = require("animation")
collision = require("collision")

local player = {}

local playerItem = {
	id = "player",
	speed = 100,
	direction = "none",
	state = "walk_down",
	x = 100,
	y = 100,
	futureX = 100,
	futureY = 100,
	width = 20,
	height = 10,
	drawXOffset = 0,
	drawYOffset = -16
}

function player.load(data)
	animation.load("player")
	animation.setInitialState(playerItem.state)
	data.player = playerItem
	table.insert(data.items, playerItem)
	return data
end

function playerItem.update(data)
	-- Determine movement direction based on keyboard input
	local playerMoved = false
	for key, _ in pairs(data.controls) do
		if love.keyboard.isDown(data.controls[key]) then
			playerItem.state = "walk_"..key
			playerMoved = true
		end
	end

	-- Move the playerItem's x and y position based on their state
	if playerMoved then
		local moveDistance = playerItem.speed * data.dt
		if playerItem.state == "walk_up" then
			playerItem.futureY = playerItem.y - moveDistance
		end
		if playerItem.state == "walk_down" then
			playerItem.futureY = playerItem.y + moveDistance
		end
		if playerItem.state == "walk_left" then
			playerItem.futureX = playerItem.x - moveDistance
		end
		if playerItem.state == "walk_right" then
			playerItem.futureX = playerItem.x + moveDistance
		end
	end

	-- Commit the future playerItem's location to the current playerItem's if the future
	-- playerItem's movement does not cause a collision
	local futureplayerItem = {
		id = playerItem.id,
		x = playerItem.futureX,
		y = playerItem.futureY,
		width = playerItem.width,
		height = playerItem.height
	}

	if playerMoved and not collision.checkCollisions(futureplayerItem, data.items) then
		playerItem.x = playerItem.futureX
		playerItem.y = playerItem.futureY
		animation.cycleFrames(data.dt, playerItem.state)
	else
		animation.reset()
	end

	playerItem.sprite = animation.getCurrentSprite()

	return data
end

return player
