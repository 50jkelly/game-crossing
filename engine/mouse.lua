local mouse = {}

-- Hooks

function love.mousepressed(x, y, button)

	local inventory = data.plugins.inventory
	local items = data.plugins.items
	local things = data.plugins.things
	local player = data.plugins.player
	local clock = data.plugins.clock

	-- What happens when the player clicks the left mouse button

	if button == 1 and inventory and items then

		-- If we are in the game state and the player has selected a placeable item
		-- and the mouse position is within the player's placeable range...place the
		-- item into the world

		if data.state == 'game' then

			local slot = inventory.getSlots()[inventory.highlightedSlot]
			local item = items[slot.item]
			local viewport = getViewport()
			x = x + viewport.x
			y = y + viewport.y

			if item and item.placeable and player.inRange({x = x, y = y}) then

				-- Remove the item from the player's inventory and place the item in
				-- the world

				inventory.removeItem(slot)
				
				if things then

					-- Add the item to the world

					things.addThing({
						type = item.placedType,
						subtype = item.placedSubtype,
						x = x - item.worldSprite.width / 2,
						y = y - item.worldSprite.height / 2,
						planted = clock.getMinutes()
					})
				end
			end
		end
	end
end
return mouse
