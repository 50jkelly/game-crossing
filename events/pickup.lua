-- Event for picking up an item

local event = {}

function event.fire(thing, eventData)
	local things = data.plugins.things
	local inventory = data.plugins.inventory
	local keyboard = data.plugins.keyboard
	local player = data.plugins.player

	-- Only fire if the player has pressed the use key

	if keyboard.currentKeyPressed ~= 'use' then
		return
	end

	-- Only fire if the player is near the thing

	local playerPosition = { x=thing.x+thing.width/2, y=thing.y+thing.height/2 }
	if not player.inRange(playerPosition) then
		return
	end

	-- When something is picked up, it is removed from the game world
	
	if things then
		things.removeThing(thing.id)
	end
	
	-- Add an item to the player's inventory based on its pickup value

	if inventory then
		for _, item in ipairs(thing.pickupItems) do
			inventory.addItem(item)
		end
	end
end

return event
