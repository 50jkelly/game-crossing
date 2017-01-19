local player = {}

-- Hooks

function player.keyDown()
	local key = data.plugins.keyboard.currentKeyDown
	local things = data.plugins.things
	local isMovementKey = key == 'up' or key == 'down' or key == 'left' or key == 'right'
	if data.state == 'game' and things and isMovementKey then
		things.setProperty('player', 'moveState', 'move_'..key)
		things.setProperty('player', 'animationState', 'move_'..key)
	end
end

function player.keyPressed()
	local key = data.plugins.keyboard.currentKeyPressed

	-- What happens when the player presses the 'use' key

	if key == 'use' then
		if data.state == 'game' then

			-- If the player has any things in their canInteract table, fire the interact function
			-- of those things

			local things = data.plugins.things
			if things then
				local canInteract = things.getProperty('player', 'canInteract')
				if canInteract then
					for _, thing in ipairs(canInteract) do
						if thing.interact then
							local interactions = data.plugins.interactions
							if interactions then
--								interactions[thing.interact](thing)
							end
						end
					end
				end
			end
		end
	end

end

function love.mousepressed(x, y, button)

	local inventory = data.plugins.inventory
	local items = data.plugins.items
	local viewport = data.plugins.viewport
	local things = data.plugins.things
	local sprites = data.plugins.sprites

	-- What happens when the player clicks the left mouse button

	if button == 1 and inventory and items then

		-- If we are in the game state and the player has selected a placeable item and the mouse
		-- position is within the player's placeable range...place the item into the world

		if data.state == 'game' then

			if viewport then
				x = x + viewport.getPluginData().x
				y = y + viewport.getPluginData().y
			end

			local slot = inventory.getSlots()[tostring(inventory.highlightedSlot)]
			local item = items[slot.item]

			if item.placeable and player.inRange({x = x, y = y}) then

				-- Remove the item from the player's inventory and place the item in the world

				inventory.removeItem(slot)
				
				if things then

					local width = 10
					local height = 10

					-- Determine the dimensions of the item in the world using its sprite

					if sprites then
						width, height = sprites.getSprite(item.worldSprite):getDimensions()
					end

					-- Add the item to the world

					things.addThing({
						x = x - width / 2,
						y = y - height / 2,
						spriteId = item.worldSprite,
						width = width,
						height = height,
						collides = false,
						trigger = 'canInteract',
						interact = 'pickup',
						pickupItem = 'seed'
					})
				end
			end
		end
	end
end

-- Public Functions

function player.inRange(point2, range)
	local things = data.plugins.things

	-- Get player data

	if things then
		local px = things.getProperty('player', 'x')
		local py = things.getProperty('player', 'y')
		local pwidth = things.getProperty('player', 'width')
		local pheight = things.getProperty('player', 'height')
		local range = range or things.getProperty('player', 'placementRange')

		local point1 = {
			x = px + pwidth / 2,
			y = py + pheight / 2
		}

		return getDistance(point1, point2) <= range
	end
end

return player
