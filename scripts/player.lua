local player = {}
player.id = nil

function player.load(thing, thingsTable)
	local sprites = data.plugins.sprites

	thing.sprite = sprites.getSprite('player_walk_down_1')
	thing.width, thing.height = thing.sprite.sprite:getDimensions()
	thing.lightSprite = sprites.getSprite('playerLight')
	thing.blockedStates = {}
	thing.frameCounter = 1
	thing.speed = 100
	thing.animationState = 'idle'
	thing.placementRange = 5000
	thing.isAnimated = true
	thing.framesPerSecond = 12
	thing.moveState = idle
	thing.canMove = true
	thing.timeSinceLastFrame = 0
	thing.layer = 5

	table.insert(thingsTable, thing)
	player.id = #thingsTable
end

function player.save(thing, rawData)
	table.insert(rawData, {
		type = thing.type,
		x = thing.x,
		y = thing.y
	})
end

-- Public Functions

function player.inRange(point2, range)
	local things = data.plugins.things

	-- Get player data

	if things then
		local playerRect = player.getRect()
		local range = range or things.getProperty('player', 'placementRange')

		if playerRect and range then
			local point1 = {
				x = playerRect.x + playerRect.width / 2,
				y = playerRect.y + playerRect.height / 2
			}
			return getDistance(point1, point2) <= range
		end
	end
end

function player.getRect()
	local things = data.plugins.things
	if things then
		local x = things.getProperty(player.id, 'x')
		local y = things.getProperty(player.id, 'y')
		local width = things.getProperty(player.id, 'width')
		local height = things.getProperty(player.id, 'height')

		return {
			x = x or 0,
			y = y or 0,
			width = width or 0,
			height = height or 0
		}
	end
end

return player
