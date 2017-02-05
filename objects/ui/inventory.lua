return {
	new = function(managers)
		local inventory = {}

		-- Basics

		inventory.width = 630
		inventory.height = 130
		inventory.x = (managers.viewport.width - inventory.width) / 2
		inventory.y = (managers.viewport.height - inventory.height) / 2

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
		end

		return inventory
	end
}
