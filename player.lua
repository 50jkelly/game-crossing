local player = {}

local playerEntity = {
	id = "player",
	animationPrefix = "player",
	framesPerSecond = 8,
	upBlocked = false,
	downBlocked = false,
	leftBlocked = false,
	rightBlocked = false,
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
	data.player = playerEntity
	table.insert(data.dynamicEntities, playerEntity)
end

function player.saveGame()
	local file = data.plugins.saveLoad.saveFilePath .. 'playerEntity.txt'
	data.plugins.saveLoad.writeTable(playerEntity, file)
end

function player.loadGame()
	local file = data.plugins.saveLoad.saveFilePath .. 'playerEntity.txt'
	playerEntity = data.plugins.saveLoad.readTable(playerEntity, file)
end

function player.keyDown()
	local key = data.plugins.controls.currentKeyDown

	if data.state == 'game' then
		if key == "up" or key =="down" or key == "left" or key == "right" then
			playerEntity.state = "walk_"..key
			player.moved = true
		end
	end
end

function playerEntity.update()
	if data.state == 'game' then
		playerEntity.oldX = playerEntity.x
		playerEntity.oldY = playerEntity.y

		if player.moved then
			local moveDistance = playerEntity.speed * data.dt
			if playerEntity.state == "walk_up" then
				if not isBlockedState(playerEntity.state) then
					clearBlockedStates()
					playerEntity.y = playerEntity.y - moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_down" then
				if not isBlockedState(playerEntity.state) then
					clearBlockedStates()
					playerEntity.y = playerEntity.y + moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_left" then
				if not isBlockedState(playerEntity.state) then
					clearBlockedStates()
					playerEntity.x = playerEntity.x - moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_right" then
				if not isBlockedState(playerEntity.state) then
					clearBlockedStates()
					playerEntity.x = playerEntity.x + moveDistance
				else
					player.colliding = true
				end
			end
		end

		if player.moved and player.colliding == false then
			playerEntity.cycleAnimation = true
		end

		if player.colliding then
			playerEntity.resetAnimation = true
		end

		player.moved = false
		player.colliding = false
	end
end

function playerEntity.collision(otherItem)
	setBlockedState(playerEntity.state)
	playerEntity.x = playerEntity.oldX
	playerEntity.y = playerEntity.oldY
end

function clearBlockedStates()
	playerEntity.upBlocked = false
	playerEntity.downBlocked = false
	playerEntity.leftBlocked = false
	playerEntity.rightBlocked = false
end

function setBlockedState(state)
	if state == 'walk_up' then playerEntity.upBlocked = true end
	if state == 'walk_down' then playerEntity.downBlocked = true end
	if state == 'walk_left' then playerEntity.leftBlocked = true end
	if state == 'walk_right' then playerEntity.rightBlocked = true end
end

function isBlockedState(state)
	return
		state == 'walk_up' and playerEntity.upBlocked or
		state == 'walk_down' and playerEntity.downBlocked or
		state == 'walk_left' and playerEntity.leftBlocked or
		state == 'walk_right' and playerEntity.rightBlocked
end

return player
