local plugin = {}
local pluginData = {}

-- Hooks

function plugin.dynamicEntitiesLoaded()
	pluginData = data.plugins.dynamicEntities.getPluginData().player
end

function plugin.keyDown()
	local key = data.plugins.controls.currentKeyDown
	if data.state == 'game' then
		if key == "up" or key =="down" or key == "left" or key == "right" then
			pluginData.state = "walk_"..key
			pluginData.moved = true
		end
	end
end

function plugin.keyPressed()
	
	local key = data.plugins.controls.currentKeyPressed
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
end

function plugin.update()
	if data.state == 'game' then
		pluginData.oldX = pluginData.x
		pluginData.oldY = pluginData.y

		if pluginData.moved then
			local moveDistance = pluginData.speed * data.dt
			if pluginData.state == "walk_up" then
				if not isBlockedState(pluginData.state) then
					clearBlockedStates()
					pluginData.y = pluginData.y - moveDistance
				else
					pluginData.colliding = true
				end
			end
			if pluginData.state == "walk_down" then
				if not isBlockedState(pluginData.state) then
					clearBlockedStates()
					pluginData.y = pluginData.y + moveDistance
				else
					pluginData.colliding = true
				end
			end
			if pluginData.state == "walk_left" then
				if not isBlockedState(pluginData.state) then
					clearBlockedStates()
					pluginData.x = pluginData.x - moveDistance
				else
					pluginData.colliding = true
				end
			end
			if pluginData.state == "walk_right" then
				if not isBlockedState(pluginData.state) then
					clearBlockedStates()
					pluginData.x = pluginData.x + moveDistance
				else
					pluginData.colliding = true
				end
			end
		end

		if pluginData.moved and pluginData.colliding == false then
			pluginData.cycleAnimation = true
		end

		if pluginData.colliding then
			pluginData.resetAnimation = true
		end

		pluginData.moved = false
		pluginData.colliding = false
	end
end

function plugin.collision()
	if pluginData.colliding then
		setBlockedState(pluginData.state)
		pluginData.x = pluginData.oldX
		pluginData.y = pluginData.oldY
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

-- Private functions

function clearBlockedStates()
	pluginData.upBlocked = false
	pluginData.downBlocked = false
	pluginData.leftBlocked = false
	pluginData.rightBlocked = false
end

function setBlockedState(state)
	if state == 'walk_up' then pluginData.upBlocked = true end
	if state == 'walk_down' then pluginData.downBlocked = true end
	if state == 'walk_left' then pluginData.leftBlocked = true end
	if state == 'walk_right' then pluginData.rightBlocked = true end
end

function isBlockedState(state)
	return
		state == 'walk_up' and pluginData.upBlocked or
		state == 'walk_down' and pluginData.downBlocked or
		state == 'walk_left' and pluginData.leftBlocked or
		state == 'walk_right' and pluginData.rightBlocked
end

return plugin
