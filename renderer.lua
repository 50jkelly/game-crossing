local renderer = {}
renderer.drawWorldPosition = true
renderer.drawTriggers = true

function renderer.draw()
	local entities = {}
	local staticEntities = data.plugins.staticEntities
	if staticEntities then
		entities = concat(staticEntities.getTable(), data.dynamicEntities)
	else
		entities = data.dynamicEntities
	end

	table.sort(entities, function(a, b)
		return a.y < b.y
	end)

	for _, entity in ipairs(entities) do
		local sprites = data.plugins.sprites
		if sprites then
			local sprite = sprites.getSprite(entity.spriteId)
			if sprite then
				local drawX = entity.x + entity.drawXOffset
				local drawY = entity.y + entity.drawYOffset
				local scale = 1
				if entity.scale then scale = entity.scale end
				love.graphics.draw(sprite, drawX, drawY, 0, scale, scale, 0, 0)
			end
		end

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

	local triggers = data.plugins.triggers
	if renderer.drawTriggers and triggers then
		for _, triggerId in ipairs(triggers.allTriggers()) do
			local rect = triggers.getRect(triggerId)
			love.graphics.setColor(0,0,255,100)
			love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
			love.graphics.setColor(255,255,255,255)
		end
	end
end

function renderer.drawUI()

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
	local controls = data.plugins.controls
	if actionBar then
		local numberOfSlots = actionBar.numberOfSlots()
		local margin = 10
		local width = 50
		local height = 50
		local totalWidth = (numberOfSlots * width) + (numberOfSlots * margin) + margin
		local x = (data.screenWidth - totalWidth) / 2
		local y = data.screenHeight - height - margin
		local startX = x

		for i=1, numberOfSlots, 1 do

			-- Draw the panels

			local panelColor = actionBar.panelColor
			local borderColor = actionBar.borderColor

			if i == actionBar.activatedSlot() then
				panelColor = actionBar.activatedPanelColor
				borderColor = actionBar.activatedBorderColor
			end

			drawPanel(x, y, width, height, panelColor, borderColor)

			-- Draw the sprite and quantity of the item in the quickslot

			local slotValue = actionBar.getSlotValue(i)
			local inventory = data.plugins.inventory
			if inventory and inventory.slots[slotValue] then
				local itemId, quantity = inventory.getItem(slotValue)
				local sprites = data.plugins.sprites
				if sprites then
					local sprite = sprites.getSprite(itemId)
					if sprite then
						love.graphics.draw(sprite, x, y)
					end
				end

				if quantity > 0 then
					local rightMargin = 12
					if quantity > 9 then
						rightMargin = 20
					end
					if quantity > 99 then
						rightMargin = 24
					end
					love.graphics.print(quantity, x + width - rightMargin, y + 4)
				end
			end

			-- Draw the shortcut key for the quickslot
			
			local shortcut = 'actionBar'..i
			local key = actionBar.getShortcutValue(shortcut)
			if controls and key then
				love.graphics.print(key, x + 4, y + height - 16)
			end

			x = x + width + 10
		end

		-- Draw player inventory
		
		if data.state == 'inventory' and data.plugins.messageBox then

			-- Draw the panel

			local backgroundColor = data.plugins.messageBox.backgroundColor
			local borderColor = data.plugins.messageBox.borderColor
			local textColor = data.plugins.messageBox.textColor
			local panelWidth = 300
			local panelHeight = 400
			local panelX = (data.screenWidth - panelWidth) / 2
			local panelY = (data.screenHeight - panelHeight) / 2
			
			drawPanel(panelX, panelY, panelWidth, panelHeight, backgroundColor, borderColor)

			-- Print the items in the player's inventory

			local lineHeight = 20
			local textYMargin = 8
			local x = panelX + margin
			local y = panelY + margin
			local startX = x
			local startY = y

			local inventory = data.plugins.inventory
			if inventory then
				for index, slot in ipairs(inventory.slots) do
					local itemId, quantity = inventory.getItem(index)

					if itemId and itemId ~= -1 then

						-- Draw the cursor
						if inventory.highlightedSlot == index then
							love.graphics.draw(inventory.cursor, x, y)
						end

						-- Print the item's quickslot shortcut
						x = x + 50
						y = y + textYMargin
						local actionBarSlot = actionBar.getSlotIndex(index)
						if actionBarSlot then
							local shortcutIndex = 'actionBar'..actionBarSlot
							local shortcutValue = actionBar.getShortcutValue(shortcutIndex)
							love.graphics.print(shortcutValue, x, y)
						end

						-- Print the item's name
						x = x + 30
						local items = data.plugins.items
						if items then
							local name = items.getName(itemId)
							if name then
								love.graphics.print(name, x, y)
							end
						end

						-- Print the item's quantity
						x = x + 80
						love.graphics.print(quantity, x, y)

						-- Draw the item's sprite if it is highlighted
						x = panelX + (panelWidth - margin - 50)
						if inventory.highlightedSlot == index then
							local sprites = data.plugins.sprites
							if sprites then
								love.graphics.draw(sprites.getSprite(itemId), x, startY)
							end
						end

						x = startX
						y = y + lineHeight - textYMargin
					end
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
