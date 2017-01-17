local interactions = {}

function interactions.plant(thing)

	-- When a plant is interacted with, it is removed from the game world
	
	local things = data.plugins.things
	if things then
		things.removeThing(thing.id)
	end

	-- When a plant is interacted with, 2 seeds are placed into the player's inventory

	local inventory = data.plugins.inventory
	if inventory then
		inventory.addItem('seed')
		inventory.addItem('seed')
	end
end

return interactions
