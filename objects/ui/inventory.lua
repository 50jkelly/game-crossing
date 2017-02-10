return function()
	local this = {}

	-- Dependencies

	local array2d = array2d or require 'pl.array2d'
	local tablex = tablex or require 'pl.tablex'

	-- Constants

	local EMPTY = 'empty'
	local ROWS = 2
	local COLUMNS = 10

	-- Mouse

	local mouse = {}

	-- Panels

	local panels = {}

	-- Slots

	local highlighted_slot = nil

	-- Trash

	local trash = {}

	-- Drag and drop

	local dragged = {}

	-- Slot information

	local function slot_info(panel, row, column)
		return {
			x = panel.x + panel.padding_x + ((panel.slot_width + panel.margin_x) * (column - 1)),
			y = panel.y + panel.padding_y + ((panel.slot_height + panel.margin_y) * (row - 1)),
			width = panel.slot_width,
			height = panel.slot_height
		}
	end

	-- Mouse over

	local function mouse_over(rect)
		return
			mouse.x > rect.x and
			mouse.x < rect.x + rect.width and
			mouse.y > rect.y and
			mouse.y < rect.y + rect.height
	end

	-- Add a panel

	function this.add_panel(args)
		panels[args.name] = args
	end

	-- Initialise

	this.initialise = function(_sprite, _slot_highlight_sprite, _trash_sprite, _slot_width, _slot_height, _main_margin_x, _main_margin_y, _slot_margin_x, _slot_margin_y, _text_color)
		panels.main = {}
		panels.main.name = 'main'
		panels.main.sprite = _sprite
		panels.main.highlight_sprite = _slot_highlight_sprite
		panels.main.slot_width = _slot_width or 50
		panels.main.slot_height = _slot_height or 50
		panels.main.padding_x = _main_margin_x or 20
		panels.main.padding_y = _main_margin_y or 10
		panels.main.margin_x = _slot_margin_x or 10
		panels.main.margin_y = _slot_margin_y or 10
		panels.main.text_color = _text_color or {0,0,0,255}
		panels.main.width, panels.main.height = panels.main.sprite:getDimensions()
		panels.main.hidden = true

		-- Slots
		panels.main.slots = array2d.new(ROWS, COLUMNS, EMPTY)

		-- Trash
		if _trash_sprite then
			panels.main.trash = {}
			panels.main.trash.sprite = _trash_sprite
			panels.main.trash.width, panels.main.trash.height = _trash_sprite:getDimensions()
		end
	end

	-- Update

	this.update = function()

		-- Mouse position
		mouse.x = love.mouse.getX()
		mouse.y = love.mouse.getY()
		mouse.left = love.mouse.isDown(1)
		mouse.right = love.mouse.isDown(2)

		-- Reset
		highlighted_slot = nil

		for _, panel in pairs(panels) do
			if not panels.main.hidden then

				-- Panel position
				panel.x = (love.graphics.getWidth() - panel.width) / 2
				panel.y = (love.graphics.getHeight() - panel.height) / 2

				-- Trash position
				if panel.trash then
					panel.trash.x = panel.x + panel.width - panel.trash.width
					panel.trash.y = panel.y + panel.height + panel.padding_y
				end

				-- Mouse hover
				for row, column, slot in array2d.iter(panel.slots, true) do
					if mouse_over(slot_info(panel, row, column)) then
						highlighted_slot = { panel, row, column }
					end
				end

				-- Drag
				if mouse.left then
					mouse.clicking = true
				end

				if not mouse.left and mouse.clicking and highlighted_slot and not dragged.item then
					mouse.clicking = false

					-- Get item details
					_, dragged.row, dragged.column = unpack(highlighted_slot)
					dragged.item = panel.slots[dragged.row][dragged.column]

					-- Get grabbed position
					local s = slot_info(panel, dragged.row, dragged.column)
					dragged.sprite_x = love.mouse.getX() - s.x
					dragged.sprite_y = love.mouse.getY() - s.y

					-- Empty slot
					panel.slots[dragged.row][dragged.column] = EMPTY
				end

				-- Drop
				if not (mouse.left) and mouse.clicking and dragged.item then
					mouse.clicking = false
					local _, row, column = unpack(highlighted_slot or {0, 0})

					-- Case 1: Dropping over another slot with a different item
					if highlighted_slot and panel.slots[row][column].name ~= dragged.item.name then
						panel.slots[dragged.row][dragged.column] = panel.slots[row][column]
						panel.slots[row][column] = dragged.item
						dragged.item = nil

						-- Case 2: Dropping over another slot
					elseif highlighted_slot then
						local remainder = this.add_item(dragged.item, panel.name, row, column, false)
						panel.slots[dragged.row][dragged.column] = remainder
						dragged.item = nil

						-- Case 3: Dropping over the trash
					elseif mouse_over(panel.trash) then
						dragged.item = nil

						-- Case 4: Dropping anywhere else
					else
						panel.slots[dragged.row][dragged.column] = dragged.item
						dragged.item = nil
					end
				end
			end
		end
	end

	-- Draw

	this.draw = function()
		for _, panel in pairs(panels) do
			if not panel.hidden then
				-- Panel
				love.graphics.draw(panel.sprite, panel.x, panel.y)

				-- Trash
				if panel.trash then
					love.graphics.draw(panel.trash.sprite, panel.trash.x, panel.trash.y)
				end

				-- Slots
				for row, column, slot in array2d.iter(panel.slots, true) do
					if slot ~= EMPTY then
						local s = slot_info(panel, row, column)
						love.graphics.draw(slot.sprite, s.x, s.y)
						love.graphics.setColor(panel.text_color)
						love.graphics.print(slot.amount, s.x + 2, s.y)
						love.graphics.setColor(255,255,255,255)
					end
				end

				-- Highlighted slot
				if highlighted_slot then
					local _, row, column = unpack(highlighted_slot)
					local s = slot_info(panel, row, column)
					love.graphics.draw(panel.highlight_sprite, s.x, s.y)
				end

				-- Drag and drop
				if dragged.item then
					local x = love.mouse.getX() - dragged.sprite_x
					local y = love.mouse.getY() - dragged.sprite_y
					love.graphics.draw(dragged.item.sprite, x, y)
					love.graphics.setColor(panel.text_color)
					love.graphics.print(dragged.item.amount, x + 2, y)
					love.graphics.setColor(255,255,255,255)
				end
			end
		end
	end

	-- Visibility

	this.toggle = function()
		panels.main.hidden = not panels.main.hidden
	end

	-- Add item

	this.add_item = function(item, panel_name, row, column, try_other_slots)

		-- Get panel
		local panel = panels[panel_name]

		-- Find next row or column
		local next = function()
			if panel.slots[row][column + 1] then return row, column + 1 end
			if panel.slots[row + 1] then return row + 1, 1 end
			return nil
		end

		-- Main function
		local function add_item(items, row, column)

			-- Base case 1: Items is empty
			if #items == 0 then
				return nil

			-- Base case 2: Inventory is full
			elseif not (row and column) then
				items[1].amount = #items
				return items[1] -- Return leftover items
			
			-- Case 1: Slot is empty
			elseif panel.slots[row][column] == EMPTY then
				panel.slots[row][column] = items[1]
				return add_item(tablex.sub(items, 2), row, column)

			-- Case 2: Slot does not contain a matching item
			elseif panel.slots[row][column].name ~= items[1].name then
				if try_other_slots then 
					row, column = next()
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 3: Slot is full
			elseif panel.slots[row][column].amount == panel.slots[row][column].stack_size then
				if try_other_slots then 
					row, column = next()
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 4: Slot is occupied but has room in stack
			else
				panel.slots[row][column].amount = panel.slots[row][column].amount + 1
				return add_item(tablex.sub(items, 2), row, column)
			end
		end

		-- Optional parameters
		if try_other_slots == nil then
			try_other_slots = true
		end

		-- Normalise item
		local items = {}

		for i=1, item.amount, 1 do
			local _item = tablex.copy(item)
			_item.amount = 1
			table.insert(items, _item)
		end

		-- Add item
		row = row or 1
		column = column or 1
		return add_item(items, row, column)

	end

	-- Find item

	this.find = function(name)
		for row, column, slot in array2d.iter(panels.main.slots, true) do
			if slot.name == name then
				return { row, column, slot }
			end
		end
		return nil
	end

	return this
end
