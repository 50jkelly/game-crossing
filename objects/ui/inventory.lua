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

	-- Drawing

	local width, height, x, y, slot_width, slot_height, main_margin_x, main_margin_y, slot_margin_x, slot_margin_y
	local sprite, hidden, text_color

	-- Initialise

	this.initialise = function(_sprite, _slot_width, _slot_height, _main_margin_x, _main_margin_y, _slot_margin_x, _slot_margin_y, _text_color)
		sprite = _sprite
		slot_width = _slot_width or 50
		slot_height = _slot_height or 50
		main_margin_x = _main_margin_x or 20
		main_margin_y = _main_margin_y or 10
		slot_margin_x = _slot_margin_x or 10
		slot_margin_y = _slot_margin_y or 10
		text_color = _text_color or {0,0,0,255}
		width, height = sprite:getDimensions()
		hidden = true
	end

	-- Draw

	this.draw = function()
		if not hidden then
			x = (love.graphics.getWidth() - width) / 2
			y = (love.graphics.getHeight() - height) / 2
			love.graphics.draw(sprite, x, y)

			for row, column, slot in array2d.iter(slots, true) do
				if slot ~= EMPTY then
					local slot_x = x + main_margin_x + ((slot_width + slot_margin_x) * (column - 1))
					local slot_y = y + main_margin_y + ((slot_height + slot_margin_y) * (row - 1))
					love.graphics.draw(slot.sprite, slot_x, slot_y)
					love.graphics.setColor(text_color)
					love.graphics.print(slot.amount, slot_x + 2, slot_y)
					love.graphics.setColor(255,255,255,255)
				end
			end
		end
	end

	-- Visibility

	this.toggle = function()
		hidden = not hidden
	end

	-- Add item

	this.add_item = function(item, row, column)

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
				return true

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
				row, column = next(row, column)
				return add_item(items, row, column)

			-- Case 3: Slot is full

			elseif slots[row][column].amount == slots[row][column].stack_size then
				row, column = next(row, column)
				return add_item(items, row, column)

			-- Case 4: Slot is occupied but has room in stack

			else
				slots[row][column].amount = slots[row][column].amount + 1
				return add_item(tablex.sub(items, 2), row, column)
			end
		end

		-- Normalise item

		local items = {}

		for i=1, item.amount, 1 do
			local _item = tablex.copy(item)
			_item.amount = 1
			table.insert(items, _item)
		end

		row = row or 1
		column = column or 1
		return add_item(items, row, column)

	end

	-- Find empty slot

	this.find_empty = function()
		for row, column, slot in array2d.iter(slots, true) do
			if slot == EMPTY then
				return { row, column, slot }
			end
		end
		return nil
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
