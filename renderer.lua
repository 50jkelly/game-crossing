local renderer = {}
renderer.drawWorldPosition = true
renderer.drawTriggers = true

function renderer.draw()
	local entities = concat(data.staticEntities, data.dynamicEntities)
	table.sort(entities, function(a, b)
		return a.y < b.y
	end)

	for _, entity in ipairs(entities) do
		if entity.sprite then
			local drawX = entity.x + entity.drawXOffset
			local drawY = entity.y + entity.drawYOffset
			love.graphics.draw(entity.sprite, drawX, drawY, 0, 1, 1, 0, 0)
		end

		if renderer.drawWorldPosition then
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", entity.x, entity.y, entity.width, entity.height)
			love.graphics.setColor(255,255,255,255)
		end
	end

	if renderer.drawTriggers and data.triggers then
		for _, trigger in ipairs(data.triggers) do
			love.graphics.setColor(0,0,255,100)
			love.graphics.rectangle("fill", trigger.x, trigger.y, trigger.width, trigger.height)
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

	-- Draw inventory quick slots
	
	local inventory = data.plugins.inventory
	if inventory then
		local totalQuickSlots = inventory.numberOfQuickSlots
		local margin = 10
		local width = 50
		local height = 50
		local totalWidth = (totalQuickSlots * width) + (totalQuickSlots * margin) + margin
		local x = (data.screenWidth - totalWidth) / 2
		local y = data.screenHeight - height - margin
		local startX = x

		for index, quickSlot in ipairs(inventory.quickSlots) do
			local slotColor = inventory.slotColor
			local borderColor = inventory.borderColor

			if index == inventory.activatedSlot then
				slotColor = inventory.activatedSlotColor
				borderColor = inventory.activatedBorderColor
			end

			if index == inventory.selectedSlot then
				borderColor = inventory.selectedBorderColor
			end

			drawPanel(x, y, width, height, slotColor, borderColor)

			if quickSlot.item and quickSlot.item.sprite then
				love.graphics.draw(quickSlot.item.sprite, x, y)
			end

			if quickSlot.key then
				love.graphics.print(quickSlot.key, x + 4, y + height - 16)
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

			for index, slot in ipairs(inventory.slots) do
				local item = slot.item
				if item then
					-- Draw the cursor
					if inventory.highlightedSlot == index then
						love.graphics.draw(inventory.cursor, x, y)
					end

					-- Print the item's quickslot location
					x = x + 50
					y = y + textYMargin
					for _, quickSlot in ipairs(inventory.quickSlots) do
						if quickSlot.item and quickSlot.item.id == item.id then
							love.graphics.print(quickSlot.key, x, y)
						end
					end
					
					-- Print the item's name
					x = x + 30
					if item.name then
						love.graphics.print(item.name, x, y)
					end

					-- Draw the item's sprite if it is highlighted
					x = panelX + (panelWidth - margin - 50)
					if inventory.highlightedSlot == index then
						love.graphics.draw(item.sprite, x, startY)
					end

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
