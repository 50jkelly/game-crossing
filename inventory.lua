local inventory = {}
inventory.slots = {}
inventory.slotQuantities = {}
inventory.highlightedSlot = 1
local numberOfSlots = 100

-- Hooks

function inventory.initialise()
	for i=1, numberOfSlots, 1 do
		inventory.slots[i] = -1
		inventory.slotQuantities[i] = -1
	end
end

function inventory.loadGraphics()
	inventory.cursor = love.graphics.newImage('images/cursor.png')
end

function inventory.assetsLoaded()
	inventory.addItem('item_book', 1)
end

function inventory.saveGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath .. 'inventory.txt'
	saveLoad.writeTable(inventory, file)

	file = saveLoad.saveFilePath .. 'inventorySlots.txt'
	saveLoad.writeTable(inventory.slots, file)

	file = saveLoad.saveFilePath .. 'inventorySlotQuantities.txt'
	saveLoad.writeTable(inventory.slotQuantities, file)
end

function inventory.loadGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath .. 'inventory.txt'
	inventory = saveLoad.readTable(inventory, file)

	file = saveLoad.saveFilePath .. 'inventorySlots.txt'
	inventory.slots = saveLoad.readArray(inventory.slots, file)

	file = saveLoad.saveFilePath .. 'inventorySlotQuantities.txt'
	inventory.slotQuantities = saveLoad.readArray(inventory.slotQuantities, file)
end

function inventory.keyPressed()
	local key = data.plugins.controls.currentKeyPressed

	if data.state == 'inventory' then
		if key == 'up' and inventory.highlightedSlot then
			if inventory.highlightedSlot > 1 then
				inventory.highlightedSlot = inventory.highlightedSlot - 1
			end
		end

		if key == 'down' and inventory.highlightedSlot then 
			if inventory.highlightedSlot < table.getn(inventory.slots) then
				inventory.highlightedSlot = inventory.highlightedSlot + 1
			end
		end

		local actionBar = data.plugins.actionBar
		if actionBar then
			if actionBar.isShortcut(key) then
				local actionBarSlot = actionBar.getShortcutValue(key)
				local inventorySlot = inventory.highlightedSlot
				actionBar.clearValueFromSlots(inventorySlot)
				actionBar.setSlotValue(actionBarSlot, inventorySlot)
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

-- Functions

function inventory.addItem(itemId, quantity)
	local slot = nextEmptySlot()
	inventory.slots[slot] = itemId
	inventory.slotQuantities[slot] = quantity
	return slot
end

function inventory.getItem(slotIndex)
	local itemId = inventory.slots[slotIndex]
	local quantity = inventory.slotQuantities[slotIndex]
	return itemId, quantity
end

function inventory.findItem(id)
	for index, itemId in ipairs(inventory.slots) do
		if itemId == id then
			return index
		end
	end
	return nil
end

function inventory.removeItem(index)
	if inventory.slotQuantities[index] == 1 then
		inventory.slots[index] = -1
		inventory.slotQuantities[index] = -1
	elseif inventory.slotQuantities[index] > 1 then
		inventory.slotQuantities[index] = inventory.slotQuantities[index] - 1
	end
end

function nextEmptySlot()
	for i, v in ipairs(inventory.slots) do
		if type(v) == 'number' and v < 0 then
			return i
		end
	end
end

return inventory
