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

	local function slot_info(row, column)
		return {
			x = panels.main.x + panels.main.padding_x + ((panels.main.slot_width + panels.main.margin_x) * (column - 1)),
			y = panels.main.y + panels.main.padding_y + ((panels.main.slot_height + panels.main.margin_y) * (row - 1)),
			width = panels.main.slot_width,
			height = panels.main.slot_height
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
		panels.main.trash = {}
		panels.main.trash.sprite = _trash_sprite
		panels.main.trash.width, panels.main.trash.height = _trash_sprite:getDimensions()
	end

	-- Update

	this.update = function()
		if not panels.main.hidden then

			-- Mouse position
			mouse.x = love.mouse.getX()
			mouse.y = love.mouse.getY()
			mouse.left = love.mouse.isDown(1)
			mouse.right = love.mouse.isDown(2)

			-- Inventory position
			panels.main.x = (love.graphics.getWidth() - panels.main.width) / 2
			panels.main.y = (love.graphics.getHeight() - panels.main.height) / 2

			-- Trash position
			panels.main.trash.x = panels.main.x + panels.main.width - panels.main.trash.width
			panels.main.trash.y = panels.main.y + panels.main.height + panels.main.padding_y

			-- Reset
			highlighted_slot = nil

			-- Mouse hover
			for row, column, slot in array2d.iter(panels.main.slots, true) do
				if mouse_over(slot_info(row, column)) then
					highlighted_slot = { row, column }
				end
			end

			-- Drag
			if mouse.left then
				mouse.clicking = true
			end

			if not mouse.left and mouse.clicking and highlighted_slot and not dragged.item then
				mouse.clicking = false

				-- Get item details
				dragged.row, dragged.column = unpack(highlighted_slot)
				dragged.item = panels.main.slots[dragged.row][dragged.column]

				-- Get grabbed position
				local s = slot_info(dragged.row, dragged.column)
				dragged.sprite_x = love.mouse.getX() - s.x
				dragged.sprite_y = love.mouse.getY() - s.y

				-- Empty slot
				panels.main.slots[dragged.row][dragged.column] = EMPTY
			end

			-- Drop
			if not (mouse.left) and mouse.clicking and dragged.item then
				mouse.clicking = false
				local row, column = unpack(highlighted_slot or {0, 0})

				-- Case 1: Dropping over another slot with a different item
				if highlighted_slot and panels.main.slots[row][column].name ~= dragged.item.name then
					panels.main.slots[dragged.row][dragged.column] = panels.main.slots[row][column]
					panels.main.slots[row][column] = dragged.item
					dragged.item = nil

				-- Case 2: Dropping over another slot
				elseif highlighted_slot then
					local remainder = this.add_item(dragged.item, row, column, false)
					panels.main.slots[dragged.row][dragged.column] = remainder
					dragged.item = nil

				-- Case 3: Dropping over the trash
				elseif mouse_over(panels.main.trash) then
					dragged.item = nil

				-- Case 4: Dropping anywhere else
				else
					panels.main.slots[dragged.row][dragged.column] = dragged.item
					dragged.item = nil
				end
			end
		end
	end

	-- Draw

	this.draw = function()
		if not panels.main.hidden then
			-- Panel
			love.graphics.draw(panels.main.sprite, panels.main.x, panels.main.y)

			-- Trash
			love.graphics.draw(panels.main.trash.sprite, panels.main.trash.x, panels.main.trash.y)

			-- Slots
			for row, column, slot in array2d.iter(panels.main.slots, true) do
				if slot ~= EMPTY then
					local s = slot_info(row, column)
					love.graphics.draw(slot.sprite, s.x, s.y)
					love.graphics.setColor(panels.main.text_color)
					love.graphics.print(slot.amount, s.x + 2, s.y)
					love.graphics.setColor(255,255,255,255)
				end
			end

			-- Highlighted slot
			if highlighted_slot then
				local row, column = unpack(highlighted_slot)
				local s = slot_info(row, column)
				love.graphics.draw(panels.main.highlight_sprite, s.x, s.y)
			end

			-- Drag and drop
			if dragged.item then
				local x = love.mouse.getX() - dragged.sprite_x
				local y = love.mouse.getY() - dragged.sprite_y
				love.graphics.draw(dragged.item.sprite, x, y)
				love.graphics.setColor(panels.main.text_color)
				love.graphics.print(dragged.item.amount, x + 2, y)
				love.graphics.setColor(255,255,255,255)
			end
		end
	end

	-- Visibility

	this.toggle = function()
		panels.main.hidden = not panels.main.hidden
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
			elseif panels.main.slots[row][column] == EMPTY then
				panels.main.slots[row][column] = items[1]
				return add_item(tablex.sub(items, 2), row, column)

			-- Case 2: Slot does not contain a matching item
			elseif panels.main.slots[row][column].name ~= items[1].name then
				if try_other_slots then 
					row, column = next(row, column)
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 3: Slot is full
			elseif panels.main.slots[row][column].amount == panels.main.slots[row][column].stack_size then
				if try_other_slots then 
					row, column = next(row, column)
				else
					row, column = nil, nil
				end
				return add_item(items, row, column)

			-- Case 4: Slot is occupied but has room in stack
			else
				panels.main.slots[row][column].amount = panels.main.slots[row][column].amount + 1
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
