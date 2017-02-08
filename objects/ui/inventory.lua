return function()
	local this = {}

	-- Dependencies

	local array2d = array2d or require 'pl.array2d'
	local tablex = tablex or require 'pl.tablex'

	-- Constants

	local EMPTY = 'empty'
	local ROWS = 2
	local COLUMNS = 10

	-- Slots

	local slots = array2d.new(ROWS, COLUMNS, EMPTY)
	local highlighted_slot = nil

	-- Drawing

	local width, height, x, y, slot_width, slot_height, main_margin_x, main_margin_y, slot_margin_x, slot_margin_y
	local sprite, slot_highlight_sprite, trash_sprite, hidden, text_color

	-- Trash
	local trash_x, trash_y, trash_width, trash_height

	-- Drag and drop

	local dragged,
		dragged_row, dragged_column,
		grabbed_x, grabbed_y

	-- Slot position

	local function slot_position(row, column)
		return
			x + main_margin_x + ((slot_width + slot_margin_x) * (column - 1)),
			y + main_margin_y + ((slot_height + slot_margin_y) * (row - 1))
	end

	-- Mouse over trash

	local function mouse_over_trash()
		local mouse_x = love.mouse.getX()
		local mouse_y = love.mouse.getY()

		return
			mouse_x > trash_x and
			mouse_x < trash_x + trash_width and
			mouse_y > trash_y and
			mouse_y < trash_y + trash_height
	end

	-- Initialise

	this.initialise = function(_sprite, _slot_highlight_sprite, _trash_sprite, _slot_width, _slot_height, _main_margin_x, _main_margin_y, _slot_margin_x, _slot_margin_y, _text_color)
		sprite = _sprite
		slot_highlight_sprite = _slot_highlight_sprite
		trash_sprite = _trash_sprite
		slot_width = _slot_width or 50
		slot_height = _slot_height or 50
		main_margin_x = _main_margin_x or 20
		main_margin_y = _main_margin_y or 10
		slot_margin_x = _slot_margin_x or 10
		slot_margin_y = _slot_margin_y or 10
		text_color = _text_color or {0,0,0,255}
		width, height = sprite:getDimensions()
		hidden = true
		trash_width, trash_height = trash_sprite:getDimensions()
	end

	-- Update

	this.update = function()
		if not hidden then

			-- Inventory position
			x = (love.graphics.getWidth() - width) / 2
			y = (love.graphics.getHeight() - height) / 2

			-- Trash position
			trash_x = x + width - trash_width
			trash_y = y + height + main_margin_y

			-- Reset
			highlighted_slot = nil

			-- Mouse hover
			for row, column, slot in array2d.iter(slots, true) do
				local slot_x, slot_y = slot_position(row, column)
				local mouse_x = love.mouse.getX()
				local mouse_y = love.mouse.getY()

				local mouse_over_slot =
					mouse_x > slot_x and
					mouse_x < slot_x + slot_width and
					mouse_y > slot_y and
					mouse_y < slot_y + slot_height

				if mouse_over_slot then
					highlighted_slot = { row, column }
				end
			end

			-- Drag
			if love.mouse.isDown(1) and highlighted_slot and not dragged then

				-- Get item details
				dragged_row, dragged_column = unpack(highlighted_slot)
				dragged = slots[dragged_row][dragged_column]

				-- Get grabbed position
				local x, y = slot_position(dragged_row, dragged_column)
				grabbed_x = love.mouse.getX() - x
				grabbed_y = love.mouse.getY() - y

				-- Empty slot
				slots[dragged_row][dragged_column] = EMPTY
			end

			-- Drop
			if not(love.mouse.isDown(1)) and dragged then
				local row, column = unpack(highlighted_slot or {0, 0})

				-- Case 1: Dropping over another slot with a different item
				if highlighted_slot and slots[row][column].name ~= dragged.name then
					slots[dragged_row][dragged_column] = slots[row][column]
					slots[row][column] = dragged
					dragged = nil

				-- Case 2: Dropping over another slot with same item
				elseif highlighted_slot then
					local remainder = this.add_item(dragged, row, column, false)
					slots[dragged_row][dragged_column] = remainder
					dragged = nil

				-- Case 3: Dropping over an empty slot
				elseif highlighted_slot and highlighted_slot == EMPTY then
					this.add_item(dragged, row, column)
					dragged = nil

				-- Case 4: Dropping over the trash
				elseif mouse_over_trash() then
					dragged = nil

				-- Case 5: Dropping anywhere else
				else
					slots[dragged_row][dragged_column] = dragged
					dragged = nil
				end
			end
		end
	end

	-- Draw

	this.draw = function()
		if not hidden then
			-- Panel
			love.graphics.draw(sprite, x, y)

			-- Trash
			love.graphics.draw(trash_sprite, trash_x, trash_y)

			-- Slots
			for row, column, slot in array2d.iter(slots, true) do
				if slot ~= EMPTY then
					local slot_x, slot_y = slot_position(row, column)
					love.graphics.draw(slot.sprite, slot_x, slot_y)
					love.graphics.setColor(text_color)
					love.graphics.print(slot.amount, slot_x + 2, slot_y)
					love.graphics.setColor(255,255,255,255)
				end
			end

			-- Highlighted slot
			if highlighted_slot then
				local row, column = unpack(highlighted_slot)
				local x, y = slot_position(row, column)
				love.graphics.draw(slot_highlight_sprite, x, y)
			end

			-- Drag and drop
			if dragged then
				local x = love.mouse.getX() - grabbed_x
				local y = love.mouse.getY() - grabbed_y
				love.graphics.draw(dragged.sprite, x, y)
				love.graphics.setColor(text_color)
				love.graphics.print(dragged.amount, x + 2, y)
				love.graphics.setColor(255,255,255,255)
			end
		end
	end

	-- Visibility

	this.toggle = function()
		hidden = not hidden
	end

	-- Add item

	this.add_item = function(item, row, column, try_other_slots)

		-- Find next row or column
		local next = function(row, column)
			if slots[row][column + 1] then return row, column + 1 end
			if slots[row + 1] then return row + 1, 1 end
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
			elseif slots[row][column] == EMPTY then
				slots[row][column] = items[1]
				return add_item(tablex.sub(items, 2), row, column)

			-- Case 2: Slot does not contain a matching item
			elseif slots[row][column].name ~= items[1].name then
				if try_other_slots then 
					row, column = next(row, column)
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 3: Slot is full
			elseif slots[row][column].amount == slots[row][column].stack_size then
				if try_other_slots then 
					row, column = next(row, column)
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 4: Slot is occupied but has room in stack
			else
				slots[row][column].amount = slots[row][column].amount + 1
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
		for row, column, slot in array2d.iter(slots, true) do
			if slot.name == name then
				return { row, column, slot }
			end
		end
		return nil
	end

	return this
end
