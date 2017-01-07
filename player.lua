local player = {
	collisionState = "none"
}

local playerItem = {
	id = "player",
	animationPrefix = "player",
	framesPerSecond = 8,
	canMove = true,
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

function player.initialise(data)
	data.player = playerItem
	table.insert(data.items, playerItem)
	return data
end

function player.keyDown(data)
	playerItem.state = "walk_"..data.plugins.controls.currentKey
	player.moved = true
	return data
end

function player.collision(data)
	player.colliding = data.plugins.collision.colliding.id == playerItem.id
	player.collisionDirection = data.plugins.collision.directions
	player.collidingWith = data.plugins.collision.collidingWith
	return data
end

function playerItem.update(data)
	playerItem.oldX = playerItem.x
	playerItem.oldY = playerItem.y

	if player.moved then
		local moveDistance = playerItem.speed * data.dt
		if playerItem.state == "walk_up" then
			if player.collisionState ~= "walk_up" then
				playerItem.y = playerItem.y - moveDistance
			end
		end
		if playerItem.state == "walk_down" then
			if player.collisionState ~= "walk_down" then
				playerItem.y = playerItem.y + moveDistance
			end
		end
		if playerItem.state == "walk_left" then
			if player.collisionState ~= "walk_left" then
				playerItem.x = playerItem.x - moveDistance
			end
		end
		if playerItem.state == "walk_right" then
			if player.collisionState ~= "walk_right" then
				playerItem.x = playerItem.x + moveDistance
			end
		end
	end

	if player.colliding then
		if player.collisionState == "none" then
			player.collisionState = playerItem.state
		end
	else
		player.collisionState = "none"
	end

	if player.moved and player.collisionState ~= playerItem.state then
		playerItem.cycleAnimation = true
	end

	if player.collisionState == playerItem.state then
		playerItem.resetAnimation = true
	end

	player.moved = false
	player.colliding = false
	return data
end

return player
