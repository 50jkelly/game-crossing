return function()
	local this = {}

	-- Dependencies

	local array2d = array2d or require 'pl.array2d'

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
		x = (love.graphics.getWidth() - width) / 2
		y = (love.graphics.getHeight() - height) / 2
		hidden = true
	end

	-- Draw

	this.draw = function()
		if not hidden then
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

		-- Can stack

		local can_stack = function(slot, item)
			return
				slot.stack_size and
				item.stack_size and
				slot.stack_size >= slot.amount + item.amount
		end

		-- Add item

		local add_item = function(row, column, item)
			if slots[row][column] == EMPTY then
				slots[row][column] = item
				return true
			elseif slots[row][column].name == item.name then
				if can_stack(slots[row][column], item) then
					slots[row][column].amount = slots[row][column].amount + item.amount
					return true
				end
			end
			return nil
		end

		-- Function body

		if row and column then
			return add_item(row, column, item)
		else
			local slot_information = this.find(item.name)
			if slot_information then
				local row, column, slot = unpack(slot_information)
				if add_item(row, column, item) then
					return true
				end
			end
			slot_information = this.find_empty()
			if slot_information then
				local row, column, slot = unpack(slot_information)
				return add_item(row, column, item)
			end
			return nil
		end

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
