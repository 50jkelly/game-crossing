return {
	new = function(managers, world)
		local cursor = {}

		-- Basics

		cursor.x = 0
		cursor.y = 0
		cursor.width = 27
		cursor.height = 25

		-- Graphics

		cursor.sprite = managers.graphics.graphics.ui.cursor_1

		-- Initialisation

		cursor.initialise = function()
			love.mouse.setVisible(false)
		end

		-- Update

		cursor.update = function(objects)
			cursor.x = love.mouse.getX()
			cursor.y = love.mouse.getY()

			local adjusted_x = cursor.x + managers.viewport.x
			local adjusted_y = cursor.y + managers.viewport.y
			local collisions = world:queryPoint(adjusted_x, adjusted_y)

			cursor.sprite = managers.graphics.graphics.ui.cursor_1
			tablex.foreach(collisions, function(collision)
				if collision.collectable then
					cursor.sprite = managers.graphics.graphics.ui.cursor_2
				end
			end)
			
		end

		-- Draw

		cursor.draw = function()
			love.graphics.draw(cursor.sprite, cursor.x, cursor.y)
		end

		return cursor
	end
}
