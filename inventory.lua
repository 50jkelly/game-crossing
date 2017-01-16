local plugin = {}
local pluginData = {}
local numberOfSlots = 10

-- Hooks

function plugin.initialise()
	plugin.loadGame()
	plugin.highlightedSlot = 1
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/inventory.lua')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/inventory.lua')
end

function plugin.loadGraphics()
	plugin.cursor = love.graphics.newImage('images/cursor.png')
end

function plugin.keyPressed()
	local key = data.plugins.controls.currentKeyPressed

	if data.state == 'inventory' then
		if key == 'up' and plugin.highlightedSlot then
			if plugin.highlightedSlot > 1 then
				plugin.highlightedSlot = plugin.highlightedSlot - 1
			end
		end

		if key == 'down' and plugin.highlightedSlot then 
			if plugin.highlightedSlot < numberOfSlots then
				plugin.highlightedSlot = plugin.highlightedSlot + 1
			end
		end

		-- Check if the key is an action bar shortcut key

		local actionBar = data.plugins.actionBar
		if actionBar and string.match(key, 'actionBar') then
			for i, actionBarSlot in pairs(actionBar.getPluginData()) do
				local shortcutKey = actionBarSlot.shortcutKey
				local inventorySlot = actionBarSlot.inventorySlot

				-- If the current slot is the slot referenced by the key pressed,
				-- set its inventory slot to the highlighted inventory slot
				if shortcutKey == key then
					actionBar.getPluginData()[i].inventorySlot = tostring(plugin.highlightedSlot)
				end

				-- If the current slot is not the slot referenced by the key pressed,
				-- and it referecnes the currently highlighted inventory slot, reset
				-- it's inventory slot reference
				if shortcutKey ~= key and inventorySlot == tostring(plugin.highlightedSlot) then
					actionBar.getPluginData()[i].inventorySlot = '0'
				end
			end
		end
	end

	if key == 'openInventory' then
		if data.state == 'game' then
			data.state = 'inventory'
		elseif data.state == 'inventory' then
			data.state = 'game'
		end
	end
end

function plugin.itemPickupFire(triggerData)

	-- Are there instances of the picked up item in the inventory?

	local inInventory
	for index, slot in pairs(pluginData) do
		if triggerData.item == slot.item then
			inInventory = slot
			break
		end
	end

	-- If the item is already in the inventory, simply increase its quantity by 1

	if inInventory then
		inInventory.amount = inInventory.amount + 1
	end

	-- If the item is not already in the inventory, check if there are empty slots for it

	local emptySlot
	if not inInventory then
		for i = 1, numberOfSlots, 1 do
			local index = tostring(i)
			local slot = pluginData[index]
			if slot.item == 'empty' then
				emptySlot = {
					slot = slot,
					index = index
				}
				break
			end
		end
	end

	-- If there is an empty slot, place this item into it with a quantity of 1

	if emptySlot then
		emptySlot.slot.item = triggerData.item
		emptySlot.slot.amount = 1
		callHook('plugins', 'newInventorySlot', emptySlot)
	end

	-- Otherwise, display an inventory full message TODO
end

function plugin.itemDrop(itemData)
	
	-- Subtract 1 from the amount of the dropped item

	itemData.inventorySlot.amount = itemData.inventorySlot.amount - 1

	-- If amount reaches 0, then remove the item from the inventory

	if itemData.inventorySlot.amount == 0 then
		itemData.inventorySlot.item = 'empty'
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

return plugin
