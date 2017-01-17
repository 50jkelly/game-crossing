local renderer = {}
renderer.drawWorldPosition = false
renderer.drawTriggers = false

function renderer.draw()

	local screenWidth = data.screenWidth
	local screenHeight = data.screenHeight
	local viewport = data.plugins.viewport
	if viewport then
		screenWidth = viewport.getPluginData().width
		screenHeight = viewport.getPluginData().height
	end

	-- Convert things table into an array for sorting

	local thingsArray
	local things = data.plugins.things
	if things then
		thingsArray = things.toArray()
	end

	-- Sort things array according to y position

	table.sort(thingsArray, function(a, b)
		return a.y < b.y
	end)

	-- Draw each thing

	for _, thing in ipairs(thingsArray) do
		local sprites = data.plugins.sprites
		if sprites then
			local sprite = sprites.getSprite(thing.spriteId)
			if sprite then
				local xOffset = thing.drawXOffset or 0
				local yOffset = thing.drawYOffset or 0
				local drawX = thing.x + xOffset
				local drawY = thing.y + yOffset
				local scale = thing.scale or 1
				love.graphics.draw(sprite, drawX, drawY, 0, scale, scale, 0, 0)
			end
		end

		-- Draw the world position

		if renderer.drawWorldPosition then
			if thing.collides then
				love.graphics.setColor(255, 0, 0, 100)
			else
				love.graphics.setColor(0, 255, 0, 100)
			end
			love.graphics.rectangle("fill", thing.x, thing.y, thing.width, thing.height)
			love.graphics.setColor(255,255,255,255)
		end
	end

	-- Draw the triggers

	local triggers = data.plugins.triggers
	if renderer.drawTriggers and triggers then
		for id, trigger in pairs(triggers.getPluginData()) do
			love.graphics.setColor(0, 0, 255, 100)
			love.graphics.rectangle("fill", trigger.x, trigger.y, trigger.width, trigger.height)
			love.graphics.setColor(255, 255, 255, 255)
		end
	end

	-- Draw the interaction indicator

	local things = data.plugins.things
	local keyboard = data.plugins.keyboard
	if data.state == 'game' and things and keyboard then

		-- We don't do anything here if the player cannot currently interact with anything

		local canInteract = things.getProperty('player', 'canInteract')

		if canInteract and table.getn(canInteract) > 0 then

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

function renderer.drawUI()

	local screenWidth = data.screenWidth
	local screenHeight = data.screenHeight
	local viewport = data.plugins.viewport
	if viewport then
		screenWidth = viewport.getPluginData().width
		screenHeight = viewport.getPluginData().height
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

	local inventory = data.plugins.inventory
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local constants = data.plugins.constants
	local items = data.plugins.items

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

			if i == tostring(inventory.highlightedSlot) then
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

	local constants = data.plugins.constants
	local inventory = data.plugins.inventory
	local items = data.plugins.items
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
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
