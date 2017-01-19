-- Event for picking up an item

local event = {}

function event.fire(thing, eventData)
	local things = data.plugins.things
	local inventory = data.plugins.inventory

	-- When something is picked up, it is removed from the game world
	
	if things then
		things.removeThing(thing.id)
	end
	
	-- Add an item to the player's inventory based on its pickup value

	if inventory and eventData.items then
		for _, item in pairs(eventData.items) do
			inventory.addItem(item)
		end
	end
end

return event
