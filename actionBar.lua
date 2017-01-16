local plugin = {}
local pluginData = {}
local numberOfSlots = 10

-- Colors
plugin.panelColor = {0, 0, 0, 100}
plugin.borderColor = {50, 50, 50, 255}
plugin.activatedPanelColor = {100, 100, 100, 100}
plugin.activatedBorderColor = {50, 50, 50, 255}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
	plugin.activatedSlot = '1'
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/actionBar.lua')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/actionBar.lua')
end

function plugin.keyPressed()
	if data.state == 'game' then
		local key = data.plugins.controls.currentKeyPressed
		for i, v in pairs(pluginData) do
			if v.shortcutKey == key then
				plugin.activatedSlot = i
			end
		end
	end
end

function plugin.newInventorySlot(hookData)

	-- Does any action bar slot currently reference this inventory slot?

	local alreadyReferenced
	for index, slot in pairs(pluginData) do
		if slot.inventorySlot == hookData.index then
			alreadyReferenced = true
			break
		end
	end

	-- If the inventory slot is not already referenced, find the next free action bar slot

	local emptySlot
	if not alreadyReferenced then
		for i = 1, numberOfSlots, 1 do
			local index = tostring(i)
			local slot = pluginData[index]
			if slot.inventorySlot == 0 then
				emptySlot = slot
				break
			end
		end
	end

	-- If we found an empty slot, set it to reference the inventory slot

	if emptySlot then
		emptySlot.inventorySlot = hookData.index
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

function plugin.getItemData()

	local inventorySlotIndex
	local inventorySlot
	local item

	-- Get the inventory slot of the currently activated action bar slot

	local inventory = data.plugins.inventory
	if inventory then
		inventorySlotIndex = plugin.activatedSlot
		inventorySlot = inventory.getPluginData()[plugin.activatedSlot]
	end

	-- Get the item in the inventory slot of the currently activated action bar slot

	local items = data.plugins.items
	if items and inventorySlot then
		item = items.getPluginData()[inventorySlot.item]
	end

	if inventorySlotIndex and inventorySlot and item then
		return {
			inventorySlotIndex = inventorySlotIndex,
			inventorySlot = inventorySlot,
			item = item
		}
	end
end

return plugin
