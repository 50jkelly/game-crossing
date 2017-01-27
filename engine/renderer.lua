local this = {}

local sprites
local constants
local items
local viewport
local geometry
local keyboard
local shaders

local light_map
local light_mask
local diffuse_canvas
local dynamic_light_shader

function this.initialise()
	sprites = data.plugins.sprites
	constants = data.plugins.constants
	items = data.plugins.items
	viewport = data.plugins.viewport
	geometry = data.libraries.geometry
	keyboard = data.plugins.keyboard
	shaders = data.plugins.shaders

	diffuse_canvas = love.graphics.newCanvas(viewport.width, viewport.height)
	light_map = love.graphics.newCanvas(viewport.width, viewport.height)
	light_mask = love.graphics.newCanvas(viewport.width, viewport.height)

	dynamic_light_shader = shaders.dynamic_light
end

function this.draw()

	clear_canvas(light_map, constants.black)
	clear_canvas(light_mask, constants.white)

	for layer_index, layer in pairs(this.to_draw) do

		-- Entity sort

		table.sort(layer, function(a, b)
			return a.height + a.y < b.height + b.y
		end)

		for _, entity in ipairs(layer) do

			-- Render diffuse canvas

			use_canvas(diffuse_canvas, 'alpha', function()
				love.graphics.draw(entity.sprite, entity.x, entity.y)
				love.graphics.setColor(constants.white)
			end)

			-- Render light map

			use_canvas(light_map, 'add', function()
				if entity.light_sprite then
					love.graphics.draw(
						entity.light_sprite
						geometry.get_center(entity).x - geometry.get_center(entity.light_sprite).x + (entity.light_offset.x or 0),
						geometry.get_center(entity).y - geometry.get_center(entity.light_sprite).y + (entity.light_offset.y or 0))
				end
			end)

			-- Render light mask

			use_canvas(light_mask, 'alpha', function()
				if entity.light_mask_sprite then
					love.graphics.draw(entity.light_mask_sprite, entity.x, entity.y)
				end
			end)
		end

		-- Render shader

		dynamic_light_shader.shader:send(dynamic_light_shader.shader)
		dynamic_light_shader.shader:send('light_mask', light_mask)

		use_canvas(nil, 'alpha', function()
			love.graphics.setShader(dynamic_light_shader.shader)
			love.graphics.draw(diffuse_canvas, viewport.x, viewport.y)
		end, 'premultiplied')

		-- Reset layer

		layer = {}
	end
end

function this.drawUI()

	local inventory = data.plugins.inventory
	local keyboard = data.plugins.keyboard
	local sprites = data.plugins.sprites
	local constants = data.plugins.constants
	local items = data.plugins.items
	local player = data.plugins.player
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

			this.drawPanel(x, y, width, height, panelColors[i == inventory.highlightedSlot], constants.black)

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

			this.drawPanel(panelX, panelY, panelWidth, panelHeight, constants.blue, constants.white)

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

local draw_panel = function(x, y, width, height, background_color, border_color)
	love.graphics.setColor(background_color)
	love.graphics.rectangle("fill", x, y, width, height, 5, 5)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", x, y, width, height, 5, 5)
	love.graphics.setColor(255, 255, 255, 255)
end

local clear_canvas = function(canvas, color)
	local viewport = getViewport()
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', viewport.x, viewport.y, viewport.width, viewport.height)
end

local use_canvas = function(canvas, mode, func, alpha)
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode(mode, (alpha or nil))
	func()
	love.graphics.setBlendMode('alpha')
	love.graphics.setShader()
	love.graphics.setCanvas()
end

return this
