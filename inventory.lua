local inventory = {}

function inventory.initialise()
	inventory.slotColor = {0, 0, 0, 100}
	inventory.borderColor = {50, 50, 50, 255}
	inventory.activatedSlotColor = {100, 100, 100, 100}
	inventory.activatedBorderColor = {50, 50, 50, 255}
	inventory.selectedBorderColor = {255, 210, 50, 255}
	inventory.cursorPosition = 0
	inventory.numberOfQuickSlots = 5

	inventory.slots = {}

	inventory.quickSlots = {}
	for i=1, inventory.numberOfQuickSlots, 1 do
		table.insert(inventory.quickSlots, {})
	end

	activateSlot(1)

	local controls = data.plugins.controls
	if controls then
		for index, _ in ipairs(inventory.quickSlots) do
			if controls.keys['inventorySlot'..index] then
				inventory.quickSlots[index].key = controls.keys['inventorySlot'..index]
			end
		end
	end
end

function inventory.loadGraphics()
	inventory.cursor = love.graphics.newImage('images/cursor.png')
end

function inventory.keyPressed()
	local key = data.plugins.controls.currentKeyPressed
	local quickSlot = string.match(key, 'inventorySlot(%d+)')
	quickSlot = tonumber(quickSlot)

	if data.state == 'game' then
		if quickSlot then
			for _, s in ipairs(inventory.quickSlots) do
				s.activated = false
			end

			if inventory.quickSlots[quickSlot] then
				activateSlot(quickSlot)
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
		if quickSlot then
			for index, slot in ipairs(inventory.slots) do
				if index == inventory.highlightedSlot then
					for _, qs in ipairs(inventory.quickSlots) do
						if qs.item == slot.item then
							qs.item = nil
						end
					end
					if inventory.quickSlots[quickSlot] then
						inventory.quickSlots[quickSlot].item = slot.item
					end
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

function inventory.addItem(item)
	table.insert(inventory.slots, {
		item = item
	})
end

function activateSlot(slot)
	inventory.activatedSlot = slot
end

return inventory
