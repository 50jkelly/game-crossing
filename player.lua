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

function player.initialise()
	player.messageBoxes = {}
	data.player = playerItem
	table.insert(data.items, playerItem)
end

function player.keyDown()
	local key = data.plugins.controls.currentKeyDown

	if key == "up" or key =="down" or key == "left" or key == "right" then
		playerItem.state = "walk_"..key
		player.moved = true
	end
end

function player.keyPressed()
	local key = data.plugins.controls.currentKeyPressed
	if key == "use" then
		showMessageBox()
	end
end

function showMessageBox()
	if table.getn(player.messageBoxes) == 0 then
		table.insert(player.messageBoxes, {
			x = 50,
			y = 425,
			width = 100,
			height = 150,
			text = "Hello! This should span multiple lines."
		})
	else
		table.remove(player.messageBoxes)
	end
end

function player.collision()
	player.colliding = data.plugins.collision.colliding.id == playerItem.id
	player.collisionDirection = data.plugins.collision.directions
	player.collidingWith = data.plugins.collision.collidingWith
end

function playerItem.update()
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
end

return player
