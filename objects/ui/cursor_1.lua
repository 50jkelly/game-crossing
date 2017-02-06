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

		-- Tooltip

		local tooltip = tooltip_library.new()

		-- Initialisation

		cursor.initialise = function()
			love.mouse.setVisible(false)

			tooltip.initialise({
				background_color = {250,242,225,255},
				border_color = {183,145,106,255},
				text_color = {183,145,106,255},
			})
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
			local name
			local collectable
			tablex.foreach(collisions, function(collision)
				if collision.player_range then is_in_range = true end
				if collision.name then name = collision.name end
				if collision.collectable then collectable = collision end
			end)

			-- Hover behaviour

			cursor.sprite = managers.graphics.graphics.ui.cursor_1
			if is_in_range and collectable then
				cursor.sprite = managers.graphics.graphics.ui.cursor_2
			end

			if name then
				tooltip.show(cursor.x, cursor.y - 30, name)
			else
				tooltip.hide()
			end

			-- Mouse down behaviour

			if managers.mouse.mousedown == 'left' then
				if is_in_range and collectable then
					collectable.current_action_timer = (collectable.current_action_timer or collectable.action_timer) - dt
					signal.emit('start_progress_bar', collectable)
					if collectable.current_action_timer <= 0 then
						collectable.remove()
						signal.emit('stop_progress_bar')
					end
				end
			else
				if collectable then
					collectable.current_action_timer = nil
					signal.emit('stop_progress_bar')
				end
			end

			-- Tooltip

			tooltip.update(dt)
			
		end

		-- Draw

		cursor.draw = function()
			love.graphics.draw(cursor.sprite, cursor.x, cursor.y)
			tooltip.draw()
		end

		return cursor
	end
}
