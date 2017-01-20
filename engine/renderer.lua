local renderer = {}
local dayNightShader
local r, g, b
renderer.drawWorldPosition = false

function renderer.initialise()

	-- Build the day/night shader

	dayNightShader = love.graphics.newShader[[
	extern number r;
	extern number g;
	extern number b;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixel = Texel(texture, texture_coords);
		vec4 night = vec4(r, g, b, 1.0);
		return pixel * night;
	}
	]]

	r = 1.0
	g = 1.0
	b = 1.0
end

function renderer.draw()
	local things = data.plugins.things
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local viewport = data.plugins.viewport
	local clock = data.plugins.clock

	local screenWidth = data.screenWidth
	local screenHeight = data.screenHeight

	if viewport then
		screenWidth, screenHeight = viewport.getDimensions()
	end

	-- Calculate the color values to send to the shader

	if clock then
		local time = clock.getTime(true)
		local totalMinutes = (time.hours * 60) + time.minutes
		local day = {r=1.0, g=1.0, b=1.0}
		local sunset = {r=1.0, g=0.5, b=1.0}
		local night = {r=0.3, g=0.3, b=0.7}
		local sunrise = {r=1, g=0.7, b=1.0}
		local sunsetTime = {start=18*60, finish=20*60}
		local nightTime = {start=21*60, finish=4*60}
		local sunriseTime = {start=5*60, finish=8*60}
		local dayTime = {start=9*60, finish=17*60}

		-- Depending on the current time, we should be changing the color values to the target
		
		local target = day
		if totalMinutes > sunriseTime.start and totalMinutes < dayTime.start then
			target = sunrise
		elseif totalMinutes > dayTime.start and totalMinutes < sunsetTime.start then
			target = day
		elseif totalMinutes > sunsetTime.start and totalMinutes < nightTime.start then
			target = sunset
		else
			target = night
		end

		if r > target.r then
			r = r - 0.005
		elseif r < target.r then
			r = r + 0.005
		end

		if g > target.g then
			g = g - 0.005
		elseif g < target.g then
			g = g + 0.005
		end

		if b > target.b then
			b = b - 0.005
		elseif b < target.b then
			b = b + 0.005
		end

		print(target.r, target.g, target.b)
		print(r, g, b)
		print()
	end

	-- Send the color values to the shader

	dayNightShader:send('r', r)
	dayNightShader:send('g', g)
	dayNightShader:send('b', b)

	for layer=1, things.maxLayers(), 1 do

	-- Convert things table into an array for sorting

	local thingsArray
	if things then
		thingsArray = things.toArray(layer)
	end

	-- Sort things array according to y position

	if layer == 5 then
		table.sort(thingsArray, function(a, b)
			return a.y < b.y
		end)
	end

	-- Draw each thing

	for _, thing in ipairs(thingsArray) do

		-- Do not draw the thing if it is not within the viewport

		local xOffset = thing.drawXOffset or 0
		local yOffset = thing.drawYOffset or 0
		local drawX = thing.x + xOffset
		local drawY = thing.y + yOffset
		local sprite = sprites.getSprite(thing.spriteId)
		local width, height = sprite:getDimensions()

		local inViewport = true
		if viewport then
			local vx, vy = viewport.getPosition()
			local vwidth, vheight = viewport.getDimensions()
			inViewport =
				drawX + width > vx and
				drawX < vx + vwidth and
				drawY + height > vy and
				drawY < vy + vheight
		end

		if inViewport then
			love.graphics.setShader(dayNightShader)
			love.graphics.draw(sprite, drawX, drawY, 0, 1, 1, 0, 0)
			love.graphics.setShader()
		end

		-- Draw the world position

		if layer == 5 and renderer.drawWorldPosition then
			if thing.collides then
				love.graphics.setColor(255, 0, 0, 100)
			else
				love.graphics.setColor(0, 255, 0, 100)
			end
			love.graphics.rectangle("fill", thing.x, thing.y, thing.width, thing.height)
			love.graphics.setColor(255,255,255,255)
		end

		-- Draw the interaction indicator

		if layer == 5 and data.state == 'game' and things and keyboard then

			-- We want to draw the interaction indicator in the following situation:
			-- 1. The current thing has an event with conditions
			-- 2. One of those conditions is "playerPressedUse"
			-- 3. All conditions are true except for the "playerPressedUse" condition

			local showIndicator

			if thing.events then
				for _, e in ipairs(thing.events) do
					if e.conditions then

						if type(e.conditions.playerPressedUse) ~= nil then
							showIndicator = true
						end

						for condition, passed in pairs(e.conditions) do
							if condition ~= 'playerPressedUse' then
								showIndicator = showIndicator and passed
							end
						end
					end
				end
			end

			if showIndicator then

				-- Get the current player position, as we will be drawing the interaction indicator
				-- right above the player's head

				local playerX = things.getProperty('player', 'x')
				local playerY = things.getProperty('player', 'y')
				local playerYOffset = things.getProperty('player', 'drawYOffset')
				local boxX = playerX + 3
				local boxY = playerY + playerYOffset - 12
				local boxWidth = 15
				local boxHeight = 15
				local labelX = playerX + 7
				local labelY = playerY + playerYOffset - 12

				-- Get the keyboard shortcut for the use command so we can display it

				local shortcut = keyboard.keys.use

				love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight, 2, 2)
				love.graphics.setColor(50, 50, 50, 255)
				love.graphics.print(shortcut, labelX, labelY)
				love.graphics.setColor(255, 255, 255, 255)
			end
		end
	end
end
end

function renderer.drawUI()

	local inventory = data.plugins.inventory
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local constants = data.plugins.constants
	local items = data.plugins.items
	local viewport = data.plugins.viewport
	local player = data.plugins.player
	local clock = data.plugins.clock

	local screenWidth = data.screenWidth
	local screenHeight = data.screenHeight
	if viewport then
		screenWidth, screenHeight = viewport.getDimensions()
		vx, vy = viewport.getPosition()
	end

	-- If the currently selected inventory item is placeable, draw it's sprite at the current
	-- mouse position

	if inventory and items then
		local slot = inventory.getSlots()[inventory.highlightedSlot] or {}
		local item = items[slot.item]

		if item and sprites and constants and item.placeable then
			local sprite = sprites.getSprite(item.worldSprite)
			local width, height = sprite:getDimensions()
			local x = love.mouse.getX() - (width / 2)
			local y = love.mouse.getY() - (height / 2)

			local color = constants.translucentRed
			if player and viewport then
				local mousePoint = {
					x = love.mouse.getX() + vx,
					y = love.mouse.getY() + vy
				}
				if player.inRange(mousePoint) then
					color = constants.translucentWhite
				end
			end

			love.graphics.setColor(color)
			love.graphics.draw(sprite, x, y)
			love.graphics.setColor(constants.white)
		end
	end

	-- Draw message boxes

	local messageBox = data.plugins.messageBox
	if messageBox then
		for _, plugin in pairs(data.plugins) do
			if plugin.messageBoxes then
				for _, box in ipairs(plugin.messageBoxes) do
					love.graphics.setColor(messageBox.backgroundColor)
					love.graphics.rectangle("fill", box.x, box.y, box.width, box.height, 5, 5)
					love.graphics.setColor(messageBox.borderColor)
					love.graphics.rectangle("line", box.x, box.y, box.width, box.height, 5, 5)
					love.graphics.setColor(messageBox.textColor)
					love.graphics.printf(box.text, box.x + 10, box.y + 10, box.width - 15)
					love.graphics.setColor(255, 255, 255, 255)
				end
			end
		end
	end

	-- Draw the action bar, which is just another view on the inventory

	if inventory and constants then
		local margin = 10 local width = 50
		local height = 50
		local totalWidth = (inventory.numberOfSlots * width) +
		(inventory.numberOfSlots * margin) + margin
		local startX = (screenWidth - totalWidth) / 2
		local y = screenHeight - height - margin

		for i, slot in pairs(inventory.getSlots()) do

			-- Determine where to draw this slot based on its index

			local x = startX + ((width + margin) * (i - 1))

			-- Draw the panels

			local panelColor = constants.translucentBlack
			local borderColor = constants.black

			if i == inventory.highlightedSlot then
				panelColor = constants.translucentGrey
			end

			drawPanel(x, y, width, height, panelColor, borderColor)

			-- Draw the sprite and quantity of the item in the action bar

			if items and sprites then
				local item = items[slot.item]
				if item then
					local sprite = sprites.getSprite(item.sprite)
					if sprite then
						love.graphics.draw(sprite, x, y)
					end
				end
			end

			if slot.amount > 0 then
				local rightMargin = 12
				if slot.amount > 9 then
					rightMargin = 20
				end
				if slot.amount > 99 then
					rightMargin = 24
				end
				love.graphics.print(slot.amount, x + width - rightMargin, y + 4)
			end

			-- Draw the shortcut key for the quickslot

			local keyboard = data.plugins.keyboard
			if keyboard then
				if keyboard then
					local shortcut = keyboard.keys[slot.shortcut]
					if shortcut then
						love.graphics.print(shortcut, x + 4, y + height - 16)
					end
				end
			end

			x = x + width + 10
		end
	end

	-- Draw player inventory

	if data.state == 'inventory' and constants and inventory then

		-- Draw the panel

		local lineHeight = 20
		local panelWidth = 300
		local panelHeight = 320
		local panelX = (screenWidth - panelWidth) / 2
		local panelY = (screenHeight - panelHeight) / 2
		local textYMargin = 8
		local margin = 10
		local x = panelX + margin
		local startY = panelY + margin
		local startX = x

		drawPanel(panelX, panelY, panelWidth, panelHeight, constants.blue, constants.white)

		-- Print the items in the player's inventory

		for index, slot in pairs(inventory.getSlots()) do

			-- Determine the correct y position based on the slot's index

			local y = startY + ((lineHeight + margin) * (index - 1))

			-- Draw the cursor

			if inventory.highlightedSlot == tonumber(index) then
				if sprites then
					love.graphics.draw(sprites.getSprite('cursor'), x, y)
				end
			end

			if slot.item ~= 'empty' then

				-- Print the item's quickslot shortcut

				x = x + 50
				y = y + textYMargin

				if keyboard then
					local shortcut = keyboard.keys[slot.shortcut]
					if shortcut then
						love.graphics.print(shortcut, x, y)
					end
				end

				-- Print the item's name

				x = x + 30
				if items then
					local name = items[slot.item].name
					if name then
						love.graphics.print(name, x, y)
					end
				end

				-- Print the item's quantity

				x = x + 80
				love.graphics.print(slot.amount, x, y)

				-- Draw the item's sprite if it is highlighted

				x = panelX + (panelWidth - margin - 50)
				if sprites then
					if inventory.highlightedSlot == tonumber(index) then
						local sprite = sprites.getSprite(items[slot.item].sprite)
						if sprite then
							love.graphics.draw(sprite, x, startY)
						end
					end
				end
			end

			-- Move the coordinates to start drawing the next line

			x = startX
			y = y + lineHeight - textYMargin
		end
	end
end

-- Private functions

function drawPanel(x, y, width, height, backgroundColor, borderColor)
	love.graphics.setColor(backgroundColor)
	love.graphics.rectangle("fill", x, y, width, height, 5, 5)
	love.graphics.setColor(borderColor)
	love.graphics.rectangle("line", x, y, width, height, 5, 5)
	love.graphics.setColor(255, 255, 255, 255)
end

return renderer
