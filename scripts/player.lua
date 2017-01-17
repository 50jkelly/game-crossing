local plugin = {}
local pluginData = {}

-- Hooks

function plugin.keyDown()
	local key = data.plugins.keyboard.currentKeyDown
	local things = data.plugins.things
	local isMovementKey = key == 'up' or key == 'down' or key == 'left' or key == 'right'
	if data.state == 'game' and things and isMovementKey then
		things.setProperty('player', 'moveState', 'move_'..key)
		things.setProperty('player', 'animationState', 'move_'..key)
	end
end

function plugin.keyPressed()
	
	local key = data.plugins.keyboard.currentKeyPressed
	if data.state == 'game' and key =='drop' then

		-- Get the item data for the currently selected action bar slot

		local itemData
		local actionBar = data.plugins.actionBar
		if actionBar then
			itemData = actionBar.getItemData()
		end

		-- If an item was found, determine where it should be dropped based on player position
		--  and direction

		if itemData then
			local x = pluginData.x
			local y = pluginData.y

			if pluginData.state == 'walk_up' then
				y = y - 35
			end

			if pluginData.state == 'walk_down' then
				y = y + pluginData.height + 5
			end

			if pluginData.state == 'walk_left' then
				x = x - 30
				y = y - 10
			end

			if pluginData.state == 'walk_right' then
				x = x + pluginData.width + 5
				y = y - 10
			end

			itemData.item.x = x
			itemData.item.y = y
		end

		-- If an item was found, get a static entity and trigger id for it

		if itemData then
			local staticEntities = data.plugins.staticEntities
			local triggers = data.plugins.triggers

			if staticEntities then
				itemData.staticEntityId = getNextFreeId(staticEntities.getPluginData(), 'item')
			end

			if triggers then
				itemData.triggerId = getNextFreeId(triggers.getPluginData(), 'trigger')
			end
		end

		-- If an item was found, call the appropriate hook

		if itemData then
			callHook('plugins', 'itemDrop', itemData)
		end
	end

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
								interactions[thing.interact](thing)
							end
						end
					end
				end
			end
		end
	end
end

function plugin.update()
	if data.state == 'game' then
		if pluginData.moved and pluginData.colliding == false then
			pluginData.cycleAnimation = true
		end

		if pluginData.colliding then
			pluginData.resetAnimation = true
		end
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

-- Private functions

return plugin
