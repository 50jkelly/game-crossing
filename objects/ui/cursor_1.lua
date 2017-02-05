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

		cursor.update = function(args)
			local objects, dt = unpack(args)

			-- Position
			cursor.x = love.mouse.getX()
			cursor.y = love.mouse.getY()

			-- Hover data

			local adjusted_x = cursor.x + managers.viewport.x
			local adjusted_y = cursor.y + managers.viewport.y
			local collisions = world:queryPoint(adjusted_x, adjusted_y)

			local is_in_range
			local collectable
			tablex.foreach(collisions, function(collision)
				if collision.player_range then is_in_range = true end
				if collision.collectable then collectable = collision end
			end)

			-- Hover behaviour

			cursor.sprite = managers.graphics.graphics.ui.cursor_1
			if is_in_range and collectable then
				cursor.sprite = managers.graphics.graphics.ui.cursor_2
			end

			-- Mouse down behaviour

			if managers.mouse.mousedown == 'left' then
				if is_in_range and collectable then
					collectable.current_action_timer = (collectable.current_action_timer or collectable.action_timer) - dt
					if collectable.current_action_timer <= 0 then
						collectable.remove()
					end
				end
			else
				if collectable then
					collectable.current_action_timer = nil
				end
			end
			
		end

		-- Draw

		cursor.draw = function()
			love.graphics.draw(cursor.sprite, cursor.x, cursor.y)
		end

		return cursor
	end
}
