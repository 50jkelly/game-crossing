local player = {}

local playerEntity = {
	id = "player",
	animationPrefix = "player",
	framesPerSecond = 8,
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
	data.player = playerEntity
	table.insert(data.dynamicEntities, playerEntity)
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
					playerEntity.blockedStates = {}
					playerEntity.y = playerEntity.y - moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_down" then
				if not isBlockedState(playerEntity.state) then
					playerEntity.blockedStates = {}
					playerEntity.y = playerEntity.y + moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_left" then
				if not isBlockedState(playerEntity.state) then
					playerEntity.blockedStates = {}
					playerEntity.x = playerEntity.x - moveDistance
				else
					player.colliding = true
				end
			end
			if playerEntity.state == "walk_right" then
				if not isBlockedState(playerEntity.state) then
					playerEntity.blockedStates = {}
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
	table.insert(playerEntity.blockedStates, playerEntity.state)
	playerEntity.x = playerEntity.oldX
	playerEntity.y = playerEntity.oldY
end

function isBlockedState(state)
	for _, blockedState in ipairs(playerEntity.blockedStates) do
		if state == blockedState then
			return true
		end
	end
	return false
end

return player
