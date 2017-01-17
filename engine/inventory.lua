local inventory = {}
local inventoryData = {}

-- Hooks

function inventory.initialise()
	inventory.loadGame()

	-- Determine the number of slots

	inventory.numberOfSlots = 0
	for _, _ in pairs(inventoryData) do
		inventory.numberOfSlots = inventory.numberOfSlots + 1
	end

	-- Set the initially highlighted slot

	inventory.highlightedSlot = 1
end

function inventory.loadGame()
	inventoryData = data.plugins.persistence.read('saves/inventory.lua')
end

function inventory.saveGame()
	data.plugins.persistence.write(pluginData, 'saves/inventory.lua')
end

function inventory.keyPressed()
	local key = data.plugins.keyboard.currentKeyPressed

	-- Change the highlighted slot in response to keyboard input

	if data.state == 'inventory' then
		if key == 'up' and inventory.highlightedSlot then
			if inventory.highlightedSlot > 1 then
				inventory.highlightedSlot = inventory.highlightedSlot - 1
			end
		end

		if key == 'down' and inventory.highlightedSlot then 
			if inventory.highlightedSlot < inventory.numberOfSlots then
				inventory.highlightedSlot = inventory.highlightedSlot + 1
			end
		end
	end

	if data.state == 'game' and string.match(key, 'actionBar') then
		for i, slot in pairs(inventoryData) do
			if slot.shortcut == key then
				inventory.highlightedSlot = tonumber(i)
			end
		end
	end

	-- Change the game state in response to keyboard input

	if key == 'openInventory' then
		if data.state == 'game' then
			data.state = 'inventory'
		elseif data.state == 'inventory' then
			data.state = 'game'
		end
	end
end

function inventory.addItem(item)

	-- Are there instances of the picked up item in the inventory?

	local inInventory
	for index, slot in pairs(inventoryData) do
		if item == slot.item then
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
		for i = 1, inventory.numberOfSlots, 1 do
			local index = tostring(i)
			local slot = inventoryData[index]
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
	end

	-- Otherwise, display an inventory full message TODO
end

function inventory.removeItem(itemData)
	
	-- Subtract 1 from the amount of the dropped item

	itemData.inventorySlot.amount = itemData.inventorySlot.amount - 1

	-- If amount reaches 0, then remove the item from the inventory

	if itemData.inventorySlot.amount == 0 then
		itemData.inventorySlot.item = 'empty'
	end
end

function inventory.getSlots()
	return inventoryData
end

return inventory
