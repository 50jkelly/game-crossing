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
		local heldItem = items[heldItemSlot.item]
		local playerRect = player.getRect()

		-- The jug

		if heldItemSlot.item == 'jug' then
			for _, thing in ipairs(player.canInteract) do
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
			local placed = items[heldItem.placed]
			local x, y = player.getItemPosition()

			if placed then
				local thing = copyThing(placed, x, y)
				thing.placedTime = clock.getMinutes()
				table.insert(things.thingsTable, thing)
			end

		-- No held item

		else
			for _, thing in ipairs(player.canInteract) do
				if thing.pickupItems then
					table.insert(things.toRemove, thing)
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
	if playerId then
		return playerId
	end
	local things = data.plugins.things
	for id, thing in ipairs(things.thingsTable) do
		if thing.type == 'player' then
			playerId = id
			return id
		end
	end
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
	if things then
		local x = things.getProperty(player.getId(), 'x')
		local y = things.getProperty(player.getId(), 'y')
		local width = things.getProperty(player.getId(), 'width')
		local height = things.getProperty(player.getId(), 'height')

		return {
			x = x or 0,
			y = y or 0,
			width = width or 0,
			height = height or 0
		}
	end
end

function player.getItemPosition(forViewport)
	local things = data.plugins.things
	local sprites = data.plugins.sprites
	local renderer = data.plugins.renderer
	local playerRect = player.getRect()
	local moveState = things.getProperty(player.getId(), 'moveState')
	local sprite = sprites.getSprite(renderer.cursorSprite)
	local itemPosition = {}
	itemPosition.move_up = {}
	itemPosition.move_down = {}
	itemPosition.move_left = {}
	itemPosition.move_right = {}
	itemPosition.idle = {}
	itemPosition.move_up.x = playerRect.x
	itemPosition.move_up.y = playerRect.y - sprite.height - 5 
	itemPosition.move_down.x = playerRect.x
	itemPosition.move_down.y = playerRect.y + playerRect.height + 5
	itemPosition.move_left.x = playerRect.x - sprite.width - 5
	itemPosition.move_left.y = playerRect.y
	itemPosition.move_right.x = playerRect.x + playerRect.width + 5
	itemPosition.move_right.y = playerRect.y
	itemPosition.idle.x = playerRect.x
	itemPosition.idle.y = playerRect.y + playerRect.height + 5

	local viewport = { x=0, y=0 }
	if forViewport then
		viewport = getViewport()
	end

	return itemPosition[moveState].x - viewport.x,
		itemPosition[moveState].y - viewport.y
end

return player
