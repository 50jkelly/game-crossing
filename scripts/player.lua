local player = {}
local playerId

-- Hooks

function player.keypressed(key)
	local inventory = data.plugins.inventory
	local items = data.plugins.items
	local things = data.plugins.things
	local dialogs = data.plugins.dialogs
	local player = data.plugins.player
	local sprites = data.plugins.sprites
	local clock = data.plugins.clock

	-- Player interaction

	if data.state == 'game' and key == 'use' then

		local heldItemSlot = inventory.getSlots()[inventory.highlightedSlot]
		local heldItem = items.new[heldItemSlot.item]()
		local playerRect = player.getRect()
		local canInteract = things.getGroup('canInteract')

		-- The jug

		if heldItemSlot.item == 'jug' then
			for _, thing in ipairs(canInteract) do
				if thing.water and heldItem.charges == 0 then
					dialogs.open('noWater')
				elseif thing.water then
					thing.water = 24 * 60
					heldItem.charges = heldItem.charges - 1
				end
			end

		-- The seed

		elseif heldItemSlot.item == 'seed' then
			inventory.removeItem(heldItemSlot)
			local placed = copyThing(items.placeable)

			if placed then
				placed.placedTime = clock.getMinutes()
				table.insert(things.thingsTable, placed)
			end

		-- No held item

		else
			for _, thing in ipairs(canInteract) do
				if thing.pickupItems then
					things.addToGroup(thing, 'toRemove')
					for _, item in ipairs(thing.pickupItems) do
						inventory.addItem(item)
					end
				end
			end
		end
	end

end

-- Public Functions

function player.getId()
	return data.plugins.things.getGroup('player')[1].id
end

function player.inRange(point2, range)
	local things = data.plugins.things

	-- Get player data

	if things then
		local playerRect = player.getRect()
		local range = range or things.getProperty(player.getId(), 'placementRange')

		if playerRect and range then
			local point1 = {
				x = playerRect.x + playerRect.width / 2,
				y = playerRect.y + playerRect.height / 2
			}
			return getDistance(point1, point2) <= range
		end
	end
	return false
end

function player.getRect()
	local things = data.plugins.things
	local player = things.getGroup('player')[1]
	if things and player then
		return {
			x = player.x or 0,
			y = player.y or 0,
			width = player.width or 0,
			height = player.height or 0
		}
	end
end

return player
