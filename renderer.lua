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

	-- Merge static and dynamic entity tables into a single array

	local entities = {}
	local staticEntities = data.plugins.staticEntities
	local dynamicEntities = data.plugins.dynamicEntities

	if staticEntities then
		for i, v in pairs(staticEntities.getPluginData()) do
			v.id = i
			table.insert(entities, v)
		end
	end

	if dynamicEntities then
		for i, v in pairs(dynamicEntities.getPluginData()) do
			v.id = i
			table.insert(entities, v)
		end
	end
	
	-- Sort the entities array according to y position

	table.sort(entities, function(a, b)
		return a.y < b.y
	end)

	-- Draw each entity

	for _, entity in ipairs(entities) do
		local sprites = data.plugins.sprites
		if sprites then
			local sprite = sprites.getSprite(entity.spriteId)
			if sprite then
				local xOffset = entity.drawXOffset or 0
				local yOffset = entity.drawYOffset or 0
				local drawX = entity.x + xOffset
				local drawY = entity.y + yOffset
				local scale = entity.scale or 1
				love.graphics.draw(sprite, drawX, drawY, 0, scale, scale, 0, 0)
			end
		end

		-- Draw the world position

		if renderer.drawWorldPosition then
			if entity.collides then
				love.graphics.setColor(255, 0, 0, 100)
			else
				love.graphics.setColor(0, 255, 0, 100)
			end
			love.graphics.rectangle("fill", entity.x, entity.y, entity.width, entity.height)
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

	-- Draw the action bar
	
	local actionBar = data.plugins.actionBar
	if actionBar then
		local slots = actionBar.getPluginData()
		local numberOfSlots = 10
		local margin = 10
		local width = 50
		local height = 50
		local totalWidth = (numberOfSlots * width) + (numberOfSlots * margin) + margin
		local startX = (screenWidth - totalWidth) / 2
		local y = screenHeight - height - margin

		for i, slot in pairs(slots) do

			-- Determine where to draw this slot based on its index

			local x = startX + ((width + margin) * (i - 1))

			-- Get all the data needed to draw this panel

			local inventory = data.plugins.inventory
			local items = data.plugins.items
			local controls = data.plugins.controls
			local sprites = data.plugins.sprites

			local inventorySlot
			if inventory then
				inventorySlot = inventory.getPluginData()[tostring(slot.inventorySlot)]
			end

			local item
			if inventorySlot and items then
				item = items.getPluginData()[inventorySlot.item]
			end

			local sprite
			if item and sprites then
				sprite = sprites.getSprite(item.sprite)
			end

			-- Draw the panels

			local panelColor = actionBar.panelColor
			local borderColor = actionBar.borderColor

			if i == actionBar.activatedSlot then
				panelColor = actionBar.activatedPanelColor
				borderColor = actionBar.activatedBorderColor
			end

			drawPanel(x, y, width, height, panelColor, borderColor)

			-- Draw the sprite and quantity of the item in the action bar

			if sprite then
				love.graphics.draw(sprite, x, y)
			end

			if inventorySlot and inventorySlot.amount > 0 then
				local rightMargin = 12
				if inventorySlot.amount > 9 then
					rightMargin = 20
				end
				if inventorySlot.amount > 99 then
					rightMargin = 24
				end
				love.graphics.print(inventorySlot.amount, x + width - rightMargin, y + 4)
			end

			-- Draw the shortcut key for the quickslot
			
			local controls = data.plugins.controls
			if controls then
				if controls then
					love.graphics.print(controls.keys[slot.shortcutKey], x + 4, y + height - 16)
				end
			end

			x = x + width + 10
		end

		-- Draw player inventory
		
		if data.state == 'inventory' and data.plugins.messageBox then

			local inventory = data.plugins.inventory
			if inventory then

				-- Draw the panel

				local slots = inventory.getPluginData()
				local backgroundColor = data.plugins.messageBox.backgroundColor
				local borderColor = data.plugins.messageBox.borderColor
				local textColor = data.plugins.messageBox.textColor
				local lineHeight = 20
				local panelWidth = 300
				local panelHeight = lineHeight * 15
				local panelX = (screenWidth - panelWidth) / 2
				local panelY = (screenHeight - panelHeight) / 2
				local textYMargin = 8
				local x = panelX + margin
				local startY = panelY + margin
				local startX = x

				drawPanel(panelX, panelY, panelWidth, panelHeight, backgroundColor, borderColor)

			-- Print the items in the player's inventory

				for index, slot in pairs(slots) do

					-- Determine the correct y position based on the slot's index

					local y = startY + ((lineHeight + margin) * (index - 1))

					-- Draw the cursor

					if inventory.highlightedSlot == tonumber(index) then
						love.graphics.draw(inventory.cursor, x, y)
					end

					if slot.item ~= 'empty' then

						-- Print the item's quickslot shortcut
						x = x + 50
						y = y + textYMargin
						local actionBar = data.plugins.actionBar
						if actionBar then
							for i, actionBarSlot in pairs(actionBar.getPluginData()) do
								if tonumber(actionBarSlot.inventorySlot) == tonumber(index) then
									local shortcutLabel = actionBarSlot.shortcutKey
									local controls = data.plugins.controls
									if controls then
										local shortcutValue = controls.keys[shortcutLabel]
										love.graphics.print(shortcutValue, x, y)
									end
								end
							end
						end

						-- Print the item's name
						x = x + 30
						local items = data.plugins.items
						if items then
							local name = items.getPluginData()[slot.item].name
							if name then
								love.graphics.print(name, x, y)
							end
						end

						-- Print the item's quantity
						x = x + 80
						love.graphics.print(slot.amount, x, y)

						-- Draw the item's sprite if it is highlighted
						x = panelX + (panelWidth - margin - 50)
						if inventory.highlightedSlot == index then
							local sprites = data.plugins.sprites
							local items = data.plugins.items
							local item = items.getPluginData()[slot.item]
							local sprite = sprites.getSprite(item.sprite)
							if sprites then
								love.graphics.draw(sprite, x, startY)
							end
						end
					end

					-- Move the coordinates to start drawing the next line

					x = startX
					y = y + lineHeight - textYMargin
				end
			end
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
