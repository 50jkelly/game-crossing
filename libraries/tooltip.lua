return {
	new = function()
		local this = {}
		local data = {
			x = 0,
			y = 0,
			width = 100,
			height = 100,
			padding = 2,
			background_color = {255,255,255,255},
			text_color = {0,0,0,255},
			border_color = {0,0,0,255},
			text = "Hello, world",
			timer = 1,
			current_timer = 1
		}
		local showing = false
		local hidden = true

		-- Update data

		local update_data = function(args)
			for index, value in pairs(data) do
				data[index] = args[index] or value
			end
		end

		-- Initialise

		this.initialise = function(args)
			update_data(args)
		end

		-- Update

		this.update = function(dt)
			if showing then
				data.current_timer = data.current_timer - dt
				if data.current_timer < 0 then
					hidden = false
					showing = false
				end
			end
		end

		-- Draw

		this.draw = function()
			if not hidden then
				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(data.background_color)
				love.graphics.rectangle("fill", data.x, data.y, data.width, data.height)
				love.graphics.setColor(data.border_color)
				love.graphics.rectangle("line", data.x, data.y, data.width, data.height)
				love.graphics.setColor(data.text_color)
				love.graphics.print(data.text, data.x + data.padding, data.y + data.padding)
				love.graphics.setColor(r, g, b, a)
			end
		end

		-- Show

		this.show = function(x, y, text)
			data.x = x or data.x
			data.y = y or data.y
			data.text = text or data.text
			data.width = font:getWidth(text) + data.padding * 2
			data.height = font:getHeight(text) + data.padding * 2
			showing = true
		end

		-- Hide

		this.hide = function()
			data.current_timer = data.timer
			hidden = true
		end

		return this
	end
}
