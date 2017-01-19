return function(thing, eventData)
	local player = data.plugins.player
	if player then
		local position = {
			x = thing.x + thing.width / 2,
			y = thing.y + thing.height / 2
		}

		return player.inRange(position, eventData.range)
	end
end
