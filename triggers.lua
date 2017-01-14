local plugin = {}
local pluginData = {}
local triggerFunctions = {}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/triggers.lua')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/triggers.lua')
end

function plugin.update()

	-- Fire triggers that are overlapping a dynamic entity

	local dynamicEntities = data.plugins.dynamicEntities
	if dynamicEntities then
		for entityIndex, entity in pairs(dynamicEntities.getPluginData()) do
			for triggerIndex, trigger in pairs(pluginData) do
				if overlapping(getRect(entity), getRect(trigger)) and not trigger.firing then
					local triggerData
					if trigger.onFire and triggerFunctions[trigger.onFire] then
						triggerData = triggerFunctions[trigger.onFire](trigger)
					end
					callHook('plugins', trigger.triggerHook..'Fire', triggerData)
					trigger.firing = true
				end
			end
		end
	end

	-- Stop firing triggers that have no entities currently firing them

	if dynamicEntities then
		for triggerIndex, trigger in pairs(pluginData) do
			if trigger.firing then
				local anyOverlapping = false
				for entityIndex, entity in pairs(dynamicEntities.getPluginData()) do
					if overlapping(getRect(entity), getRect(trigger)) then
						anyOverlapping = true
						break
					end
				end
				if not anyOverlapping then
					local triggerData
					if trigger.onStop and triggerFunctions[trigger.onStop] then
						triggerData = triggerFunctions[trigger.onStop](trigger)
					end
					callHook('plugins', trigger.triggerHook..'Stop', triggerData)
					trigger.firing = false
				end
			end
		end
	end
end

function plugin.itemPickupFire(triggerData)
	pluginData[triggerData.trigger] = nil
end

function plugin.itemDrop(itemData)

	-- Add a new trigger for picking the item back up

	pluginData[itemData.triggerId] = {
		x = itemData.item.x,
		y = itemData.item.y,
		width = 25,
		height = 25,
		onFire = 'itemPickup',
		triggerHook = 'itemPickup',
		data = {
			entity = itemData.staticEntityId,
			item = itemData.inventorySlot.item,
			trigger = itemData.triggerId
		}
	}
end

-- Trigger functions

function triggerFunctions.itemPickup(trigger)
	return {
		entity = trigger.data.entity,
		item = trigger.data.item,
		trigger = trigger.data.trigger
	}
end

function triggerFunctions.playerHolding(trigger)
	local actionBar = data.plugins.actionBar
	if actionBar then
		local itemData = actionBar.getItemData()
		if itemData then
			return {
				amount = itemData.inventorySlot.amount,
				name = itemData.item.name
			}
		end
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

-- Private functions

function getRect(thing)
	return {
		x = thing.x,
		y = thing.y,
		width = thing.width,
		height = thing.height
	}
end

return plugin
