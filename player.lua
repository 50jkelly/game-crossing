local player = {}


local playerItem = {
	id = "player",
	animationPrefix = "player",
	framesPerSecond = 8,
	canMove = true,
	blockedStates = {},
	speed = 100,
	direction = "none",
	state = "walk_down",
	x = 100,
	y = 100,
	oldX = 100,
	oldY = 100,
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

function playerItem.update()
	playerItem.oldX = playerItem.x
	playerItem.oldY = playerItem.y

	if player.moved then
		local moveDistance = playerItem.speed * data.dt
		if playerItem.state == "walk_up" then
			if not isBlockedState(playerItem.state) then
				playerItem.blockedStates = {}
				playerItem.y = playerItem.y - moveDistance
			else
				player.colliding = true
			end
		end
		if playerItem.state == "walk_down" then
			if not isBlockedState(playerItem.state) then
				playerItem.blockedStates = {}
				playerItem.y = playerItem.y + moveDistance
			else
				player.colliding = true
			end
		end
		if playerItem.state == "walk_left" then
			if not isBlockedState(playerItem.state) then
				playerItem.blockedStates = {}
				playerItem.x = playerItem.x - moveDistance
			else
				player.colliding = true
			end
		end
		if playerItem.state == "walk_right" then
			if not isBlockedState(playerItem.state) then
				playerItem.blockedStates = {}
				playerItem.x = playerItem.x + moveDistance
			else
				player.colliding = true
			end
		end
	end

	if player.moved and player.colliding == false then
		playerItem.cycleAnimation = true
	end

	if player.colliding then
		playerItem.resetAnimation = true
	end

	player.moved = false
	player.colliding = false
end

function playerItem.collision(otherItem)
	table.insert(playerItem.blockedStates, playerItem.state)
	playerItem.x = playerItem.oldX
	playerItem.y = playerItem.oldY
end

function isBlockedState(state)
	for _, blockedState in ipairs(playerItem.blockedStates) do
		if state == blockedState then
			return true
		end
	end
	return false
end

return player
