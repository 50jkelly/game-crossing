local inventory = {}

function inventory.initialise()
	inventory.slotColor = {0, 0, 0, 100}
	inventory.borderColor = {50, 50, 50, 255}
	inventory.activatedSlotColor = {100, 100, 100, 100}
	inventory.activatedBorderColor = {50, 50, 50, 255}
	inventory.selectedBorderColor = {255, 210, 50, 255}
	inventory.numberOfQuickSlots = 5

	inventory.slots = {}

	inventory.quickSlots = {}
	for i=1, inventory.numberOfQuickSlots, 1 do
		table.insert(inventory.quickSlots, 0)
	end

	inventory.activatedSlot = 1

	local controls = data.plugins.controls
	if controls then
		inventory.quickSlotKeys = {}
		for _, _ in ipairs(inventory.quickSlots) do
			table.insert(inventory.quickSlotKeys, nil)
		end
		for index, _ in ipairs(inventory.quickSlots) do
			if controls.keys['inventorySlot'..index] then
				inventory.quickSlotKeys[index] = 'inventorySlot'..index
			end
		end
	end
end

function inventory.loadGraphics()
	inventory.cursor = love.graphics.newImage('images/cursor.png')
end

function inventory.saveGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath .. 'inventory.txt'
	saveLoad.writeTable(inventory, file)

	file = saveLoad.saveFilePath .. 'quickSlots.txt'
	saveLoad.writeTable(inventory.quickSlots, file)

	file = saveLoad.saveFilePath .. 'inventorySlots.txt'
	saveLoad.writeTable(inventory.slots, file)
end

function inventory.loadGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath .. 'inventory.txt'
	inventory = saveLoad.readTable(inventory, file)

	file = saveLoad.saveFilePath .. 'quickSlots.txt'
	inventory.quickSlots = saveLoad.readArray(inventory.quickSlots, file)

	file = saveLoad.saveFilePath .. 'inventorySlots.txt'
	inventory.slots = saveLoad.readArray(inventory.slots, file)
end

function inventory.keyPressed()
	local key = data.plugins.controls.currentKeyPressed
	local isQuickSlot = string.match(key, 'inventorySlot(%d+)')

	if data.state == 'game' then
		if isQuickSlot then
			for index, qsKey in ipairs(inventory.quickSlotKeys) do
				if key == qsKey then
					inventory.activatedSlot = index
				end
			end
		end
	end

	if data.state == 'inventory' then
		if key == 'up' and inventory.highlightedSlot > 1 then
			inventory.highlightedSlot = inventory.highlightedSlot - 1
		end

		if key == 'down' and inventory.highlightedSlot < table.getn(inventory.slots) then
			inventory.highlightedSlot = inventory.highlightedSlot + 1
		end

		if isQuickSlot then
			for i, v in ipairs(inventory.quickSlots) do
				if v == inventory.highlightedSlot then
					inventory.quickSlots[i] = 0
				end
			end
			if tonumber(isQuickSlot) <= inventory.numberOfQuickSlots then
				inventory.quickSlots[tonumber(isQuickSlot)] = inventory.highlightedSlot
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

function inventory.addItem(item)
	table.insert(inventory.slots, item.id)
end

function inventory.getItem(slot)
	local item = nil
	local items = data.plugins.items
	if items then
		for itemId, value in pairs(items.itemLookup) do
			if itemId == slot then
				item = value
			end
		end
	end
	return item
end

return inventory
