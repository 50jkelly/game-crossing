return {
	new = function(managers)
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

		cursor.update = function()
			cursor.x = love.mouse.getX()
			cursor.y = love.mouse.getY()
		end

		-- Draw

		cursor.draw = function()
			love.graphics.draw(cursor.sprite, cursor.x, cursor.y)
		end

		return cursor
	end
}
