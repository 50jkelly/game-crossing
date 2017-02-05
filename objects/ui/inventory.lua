return {
	new = function(managers)
		local inventory = {}

		-- Basics

		inventory.width = 630
		inventory.height = 130
		inventory.x = (managers.viewport.width - inventory.width) / 2
		inventory.y = (managers.viewport.height - inventory.height) / 2

		-- Slots

		inventory.slots = tablex.new(20, 'empty')
		local slot_positions = {
			{x = 20, y = 10},
			{x = 40, y = 10},
			{x = 60, y = 10},
			{x = 80, y = 10},
			{x = 100, y = 10},
			{x = 120, y = 10},
			{x = 140, y = 10},
			{x = 160, y = 10},
			{x = 180, y = 10},
			{x = 200, y = 10},
			{x = 20, y = 70},
			{x = 40, y = 70},
			{x = 60, y = 70},
			{x = 80, y = 70},
			{x = 110, y = 70},
			{x = 120, y = 70},
			{x = 140, y = 70},
			{x = 160, y = 70},
			{x = 180, y = 70},
			{x = 200, y = 70},
		}

		-- Drawing

		inventory.sprite = managers.graphics.graphics.ui.inventory.inventory_20
		inventory.hidden = true

		-- Initialise

		inventory.initialise = function()
			signal.register('keypressed', function(key)
				if key == 'inventory' then
					inventory.hidden = not inventory.hidden
				end
			end)
		end

		-- Update

		inventory.update = function()
		end

		-- Draw

		inventory.draw = function()
			tablex.foreach(inventory.slots, function(slot, index)
				if slot.sprite then
					local x = inventory.x + slot_positions[index].x
					local y = inventory.y + slot_positions[index].y
					love.graphics.draw(slot.sprite, x, y)
				end
			end)
		end

		-- Add an item

		inventory.add = function(item)
			local free_slot = tablex.find(inventory.slots, 'empty')
			if free_slot then
				inventory.slots[free_slot] = item
			end
		end

		return inventory
	end
}
