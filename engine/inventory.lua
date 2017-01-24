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
	data.plugins.persistence.write(inventoryData, 'saves/inventory.lua')
end

function inventory.keypressed()
	local keyboard = data.plugins.keyboard

	if data.state == 'inventory' and keyboard.keyPressed == 'up' then
		inventory.highlightedSlot = math.max(1, inventory.highlightedSlot - 1)
	elseif data.state == 'inventory' and keyboard.keyPressed == 'down' then
		inventory.highlightedSlot = math.min(inventory.numberOfSlots, inventory.highlightedSlot + 1)
	end

	if data.state == 'game' and string.match(keyboard.keyPressed, 'actionBar') then
		for i, slot in pairs(inventoryData) do
			if slot.shortcut == keyboard.keyPressed then
				inventory.highlightedSlot = tonumber(i)
			end
		end
	end

	if keyboard.keyPressed == 'openInventory' then
		local states = {
			game = 'inventory',
			inventory = 'game'
		}
		data.state = states[data.state]
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
			local index = i
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
		emptySlot.slot.item = item
		emptySlot.slot.amount = 1
	end

	-- Otherwise, display an inventory full message TODO
end

function inventory.removeItem(slot)
	
	-- Subtract 1 from the amount of the dropped item

	slot.amount = slot.amount - 1

	-- If amount reaches 0, then remove the item from the inventory

	if slot.amount == 0 then
		slot.item = 'empty'
	end
end

function inventory.getSlots()
	return inventoryData
end

return inventory
