local renderer = {}
renderer.toDraw = {{}, {}, {}, {}, {}, {}}

function renderer.draw()

	-- Get plugins

	local things = data.plugins.things
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local shaders = data.plugins.shaders
	local constants = data.plugins.constants

	-- Define variables

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	-- Set up canvases

	local diffuseCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
	local lightBlockCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
	local resultCanvas = love.graphics.newCanvas(screenWidth, screenHeight)

	love.graphics.setCanvas(lightBlockCanvas)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(constants.white)
	local viewport = getViewport()
	love.graphics.rectangle('fill',
		viewport.x,
		viewport.y,
		screenWidth,
		screenHeight)

	-- Set up shaders

	local dynamicLightShader = shaders.dynamicLight or { shader = nil }

	-- Start drawing

	for layer=1, table.getn(renderer.toDraw), 1 do

		for _, thing in ipairs(renderer.toDraw[layer]) do
			love.graphics.setCanvas(diffuseCanvas)
			love.graphics.setBlendMode('alpha')
			love.graphics.draw(thing.sprite.sprite, thing.x, thing.y)

			if thing.lightBlockSprite then
				love.graphics.setCanvas(lightBlockCanvas)
				love.graphics.draw(thing.lightBlockSprite.sprite, thing.x, thing.y)
			end
		end

		-- Render the diffuse canvas using the dynamic light shader

		love.graphics.setCanvas(resultCanvas)
		love.graphics.setShader(dynamicLightShader.shader)
		dynamicLightShader.shader:send('lightBlockMap', lightBlockCanvas)
		local viewport = getViewport()
		love.graphics.draw(diffuseCanvas, viewport.x, viewport.y)

		-- Draw the final canvas to the screen

		love.graphics.setShader()
		love.graphics.setCanvas()
		love.graphics.setBlendMode("alpha", "premultiplied")
		local viewport = getViewport()
		love.graphics.draw(resultCanvas, viewport.x, viewport.y)
		love.graphics.setBlendMode("alpha")

		for _, thing in ipairs(renderer.toDraw[layer]) do

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

					-- Get the current player position, as we will be drawing the interaction
					-- indicator right above the player's head

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

	-- Clear our toDraw list for the next pass

	renderer.toDraw = {{}, {}, {}, {}, {}, {}}
end

function renderer.drawUI()

	local inventory = data.plugins.inventory
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local constants = data.plugins.constants
	local items = data.plugins.items
	local player = data.plugins.player
	local clock = data.plugins.clock
	local viewport = getViewport()

	-- If the currently selected inventory item is placeable, draw it's sprite at the current
	-- mouse position

	if inventory and items then
		local slot = inventory.getSlots()[inventory.highlightedSlot] or {}
		local item = items[slot.item]

		if item and sprites and constants and item.placeable then
			local sprite = sprites.getSprite(item.worldSprite)
			local x = love.mouse.getX() - (sprite.width / 2)
			local y = love.mouse.getY() - (sprite.height / 2)

			local color = constants.translucentRed
			if player then
				local mousePoint = {
					x = love.mouse.getX() + viewport.x,
					y = love.mouse.getY() + viewport.y
				}
				if player.inRange(mousePoint) then
					color = constants.translucentWhite
				end
			end

			love.graphics.setColor(color)
			love.graphics.draw(sprite.sprite, x, y)
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
		local startX = (viewport.width - totalWidth) / 2
		local y = viewport.height - height - margin

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
						love.graphics.draw(sprite.sprite, x, y)
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
		local viewport = getViewport()
		local panelX = (viewport.width - panelWidth) / 2
		local panelY = (viewport.height - panelHeight) / 2
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
					love.graphics.draw(sprites.getSprite('cursor').sprite, x, y)
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
							love.graphics.draw(sprite.sprite, x, startY)
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
