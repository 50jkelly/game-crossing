local renderer = {}
renderer.toDraw = {{}, {}, {}, {}, {}, {}}

function renderer.draw()

	local things = data.plugins.things
	local sprites = data.plugins.sprites
	local constants = data.plugins.constants
	local items = data.plugins.items
	local viewport = getViewport()

	-- Start drawing

	renderer.clearCanvas(renderer.lightCanvas, constants.black)
	renderer.clearCanvas(renderer.lightBlockCanvas, constants.white)

	for layer=1, #renderer.toDraw, 1 do
		-- Sort the layer by y position

		table.sort(renderer.toDraw[layer], function(a, b)
			return a.height + a.y < b.height + b.y
		end)

		for _, thing in ipairs(renderer.toDraw[layer]) do

			-- Render sprites to the diffuse canvas

			renderer.useCanvas(renderer.diffuseCanvas, 'alpha', function()

				-- Render the placeable item

				if things.inGroup(thing, 'player') and items.placeable then
					love.graphics.setColor(constants.translucentWhite)
					love.graphics.draw(sprites.getSprite(items.placeable.sprite).sprite, items.placeable.x, items.placeable.y)
					love.graphics.setColor(constants.white)
				end

				if things.inGroup(thing, 'canInteract') then
					love.graphics.setColor(constants.green)
				end

				love.graphics.draw(sprites.getSprite(thing.sprite).sprite, thing.x, thing.y)
				love.graphics.setColor(constants.white)
			end)

			-- Render lights to the lights canvas

			renderer.useCanvas(renderer.lightCanvas, 'add', function()
				if thing.light then
					love.graphics.draw(
					sprites.getSprite(thing.light).sprite,
					thing.x + thing.width / 2 - sprites.getSprite(thing.light).width / 2 + (thing.lightOffsetX or 0),
					thing.y + thing.height / 2 - sprites.getSprite(thing.light).height / 2 + (thing.lightOffsetY or 0))
				end
			end)

			-- Render light blockers to the lightblock canvas

			renderer.useCanvas(renderer.lightBlockCanvas, 'alpha', function()
				if thing.lightBlockSprite then
					love.graphics.draw(sprites.getSprite(thing.lightBlockSprite).sprite, thing.x, thing.y)
				end
			end)
		end

		-- Render to the screen using the dynamic lighting shader

		renderer.dynamicLightShader.shader:send('lightMap', renderer.lightCanvas)
		renderer.dynamicLightShader.shader:send('lightBlockMap', renderer.lightBlockCanvas)

		renderer.useCanvas(nil, 'alpha', function()
			love.graphics.setShader(renderer.dynamicLightShader.shader)
			love.graphics.draw(renderer.diffuseCanvas, viewport.x, viewport.y)
		end, 'premultiplied')

		-- Render dialog boxes

		if data.dialog then
			love.graphics.setColor(constants.blue)
			love.graphics.rectangle("fill", data.dialog.x, data.dialog.y, data.dialog.width, data.dialog.height, 5, 5)
			love.graphics.setColor(constants.white)
			love.graphics.rectangle("line", data.dialog.x, data.dialog.y, data.dialog.width, data.dialog.height, 5, 5)
			love.graphics.print(data.dialog.text, data.dialog.x + 10, data.dialog.y + 10)
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
	local things = data.plugins.things
	local viewport = getViewport()

	if inventory and items and constants then

		-- Draw the action bar, which is just another view on the inventory

		local margin = 10
		local width = 50
		local height = 50
		local totalWidth = (inventory.numberOfSlots * width) + (inventory.numberOfSlots * margin) + margin
		local startX = (viewport.width - totalWidth) / 2
		local panelColors = {}
		panelColors[true] = constants.translucentGrey
		panelColors[false] = constants.translucentBlack

		for i, slot in pairs(inventory.getSlots()) do

			local x = startX + (width + margin) * (i - 1)
			local y = viewport.height - height - margin

			-- Draw the panels

			renderer.drawPanel(x, y, width, height, panelColors[i == inventory.highlightedSlot], constants.black)

			-- Draw the sprite and quantity of the item in the action bar

			if items and sprites and slot.amount > 0 then
				local item = items.new[slot.item]()
				local rightMargin = 12 + (string.len(tostring(slot.amount)) - 1) * 8
				love.graphics.draw(sprites.getSprite(item.sprite).sprite, x, y)
				love.graphics.print(slot.amount, x + width - rightMargin, y + 4)
			end

			-- Draw the shortcut key

			if keyboard and keyboard.keys[slot.shortcut] then
				love.graphics.print(keyboard.keys[slot.shortcut], x + 4, y + height - 16)
			end
		end

		if data.state == 'inventory' then

			-- Draw player inventory

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

			renderer.drawPanel(panelX, panelY, panelWidth, panelHeight, constants.blue, constants.white)

			-- Print the items in the player's inventory

			for index, slot in ipairs(inventory.getSlots()) do

				-- Determine the correct y position based on the slot's index

				local y = startY + ((lineHeight + margin) * (index - 1))

				-- Draw the cursor

				if inventory.highlightedSlot == index then
					if sprites then
						love.graphics.draw(sprites.getSprite('cursor').sprite, x, y)
					end
				end

				if slot.item ~= 'empty' then

					-- Print the item's quickslot shortcut

					if keyboard and keyboard.keys[slot.shortcut] then
						love.graphics.print(keyboard.keys[slot.shortcut], x + 50, y + textYMargin)
					end

					-- Print the item's name

					local item = items.getInstance(slot.item)
					if item.name then
						love.graphics.print(item.name, x + 80, y + textYMargin)
					end

					-- Print the item's quantity

					love.graphics.print(slot.amount, x + 160, y + textYMargin)

					-- Draw the item's sprite if it is highlighted

					if inventory.highlightedSlot == index then
						love.graphics.draw(sprites.getSprite(item.sprite).sprite, panelX + (panelWidth - margin - 50), startY)
					end
				end
			end
		end
	end
end

-- Private functions

function renderer.drawPanel(x, y, width, height, backgroundColor, borderColor)
	love.graphics.setColor(backgroundColor)
	love.graphics.rectangle("fill", x, y, width, height, 5, 5)
	love.graphics.setColor(borderColor)
	love.graphics.rectangle("line", x, y, width, height, 5, 5)
	love.graphics.setColor(255, 255, 255, 255)
end

function renderer.clearCanvas(canvas, color)
	local viewport = getViewport()
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', viewport.x, viewport.y, viewport.width, viewport.height)
end

function renderer.useCanvas(canvas, mode, func, alpha)
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode(mode, (alpha or nil))
	func()
	love.graphics.setBlendMode('alpha')
	love.graphics.setShader()
	love.graphics.setCanvas()
end

function renderer.initialise()
	local viewport = getViewport()
	local shaders = data.plugins.shaders
	renderer.mainCanvas = love.graphics.newCanvas(viewport.width, viewport.height)
	renderer.diffuseCanvas = love.graphics.newCanvas(viewport.width, viewport.height)
	renderer.lightCanvas = love.graphics.newCanvas(viewport.width, viewport.height)
	renderer.lightBlockCanvas = love.graphics.newCanvas(viewport.width, viewport.height)
	renderer.dynamicLightShader = shaders.dynamicLight
end

return renderer
