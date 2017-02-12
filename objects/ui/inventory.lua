return function()
	local this = {}

	-- Dependencies

	local array2d = array2d or require 'pl.array2d'
	local tablex = tablex or require 'pl.tablex'

	-- Constants

	this.EMPTY = 'empty'

	-- Mouse

	local mouse = {}

	-- Panels

	local panels = {}

	-- Slots

	local highlighted_slot = nil

	-- Trash

	local trash

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

	-- Add panel

	function this.add_panel(args)
		local defaults = {
			slot_width = 50,
			slot_height = 50,
			padding_x = 20,
			padding_y = 10,
			margin_x = 10,
			margin_y = 10,
			text_color = {0,0,0,255},
			rows = 1,
			columns = 10,
			drag_and_drop_enabled = true,
		}

		panels[args.name] = {}

		for index, _ in pairs(args) do
			panels[args.name][index] = args[index]
		end

		for index, _ in pairs(defaults) do
			if panels[args.name][index] == nil then
				panels[args.name][index] = defaults[index]
			end
		end

		panels[args.name].width, panels[args.name].height = panels[args.name].sprite:getDimensions()

		local rows = args.rows or defaults.rows
		local columns = args.columns or defaults.columns
		panels[args.name].slots = array2d.new(rows, columns, this.EMPTY)
	end

	-- Initialise

	this.initialise = function(_trash_sprite)

		-- Trash
		if _trash_sprite then
			trash = {}
			trash.hidden = true
			trash.sprite = _trash_sprite
			trash.width, trash.height = _trash_sprite:getDimensions()
		end
	end

	-- Update

	this.update = function()

		-- Reset
		highlighted_slot = nil

		-- Mouse position
		mouse.x = love.mouse.getX()
		mouse.y = love.mouse.getY()
		mouse.left = love.mouse.isDown(1)
		mouse.right = love.mouse.isDown(2)

		for _, panel in pairs(panels) do
			if not panel.hidden then

				-- Panel position
				panel.position(panel)

				-- Mouse hover
				for row, column, slot in array2d.iter(panel.slots, true) do
					if mouse_over(slot_info(panel, row, column)) then
						highlighted_slot = { panel, row, column }
					end
				end
			end
		end

		-- Trash position
		if trash then
			if panels.main.x and panels.main.y then
				trash.x = panels.main.x + panels.main.width - trash.width
				trash.y = panels.main.y + panels.main.height + panels.main.padding_y
			end
		end

		-- Get clicked item
		if mouse.left then
			mouse.clicking = true
		end

		if not mouse.left and mouse.clicking then
			mouse.clicking = false

			-- Get item details
			local clicked = {}

			if highlighted_slot then
				clicked.panel, clicked.row, clicked.column = unpack(highlighted_slot)
				clicked.item = clicked.panel.slots[clicked.row][clicked.column]
			
				-- Clicked callback
				if clicked.panel.onclick then
					clicked.panel.onclick(clicked)
				end
			end

			-- Drop
			if dragged.item then

				-- Case 1: Dropping over the trash
				local dropping_over_trash =
					trash and
					(not trash.hidden) and
					mouse_over(trash)

				local dropping_outside_panel =
					(not clicked.panel) or
					(not clicked.panel.drag_and_drop_enabled)

				local dropping_over_different_item =
					clicked.panel and
					clicked.panel.drag_and_drop_enabled and
					clicked.panel.slots[clicked.row][clicked.column].name ~= dragged.item.name

				local dropping_over_same_item =
					clicked.panel and
					clicked.panel.drag_and_drop_enabled

				if dropping_over_trash then
					dragged.item = nil

				-- Case 2: Dropping outside a panel
				elseif dropping_outside_panel then
					dragged.panel.slots[dragged.row][dragged.column] = dragged.item
					dragged.item = nil

				-- Case 3: Dropping over another slot with a different item
				elseif dropping_over_different_item then
					dragged.panel.slots[dragged.row][dragged.column] = clicked.panel.slots[clicked.row][clicked.column]
					clicked.panel.slots[clicked.row][clicked.column] = dragged.item
					dragged.item = nil

				-- Case 4: Dropping over another slot
				elseif dropping_over_same_item then
					local remainder = this.add_item(dragged.item, clicked.panel.name, clicked.row, clicked.column, false)
					dragged.panel.slots[dragged.row][dragged.column] = remainder
					dragged.item = nil
				end

			-- Drag
			elseif clicked.panel and clicked.panel.drag_and_drop_enabled then
				if clicked.item ~= this.EMPTY then
					dragged = clicked

					-- Get grabbed position
					local s = slot_info(clicked.panel, clicked.row, clicked.column)
					dragged.sprite_x = love.mouse.getX() - s.x
					dragged.sprite_y = love.mouse.getY() - s.y

					-- Empty slot
					dragged.panel.slots[dragged.row][dragged.column] = this.EMPTY
				else
					dragged.item = nil
				end
			end
		end
	end

	-- Draw

	this.draw = function()
		-- Trash
		if trash and not trash.hidden then
			love.graphics.draw(trash.sprite, trash.x, trash.y)
		end

		for _, panel in pairs(panels) do
			if not panel.hidden then
				-- Panel
				love.graphics.draw(panel.sprite, panel.x, panel.y)

				-- Slots
				for row, column, slot in array2d.iter(panel.slots, true) do
					if slot ~= this.EMPTY then
						local s = slot_info(panel, row, column)
						love.graphics.draw(slot.sprite, s.x, s.y)
						love.graphics.setColor(panel.text_color)
						love.graphics.print(slot.amount, s.x + 2, s.y)
						love.graphics.setColor(255,255,255,255)
					end
				end

				-- Highlighted slot
				if highlighted_slot then
					local highlighted_panel, row, column = unpack(highlighted_slot)
					if highlighted_panel.name == panel.name then
						local s = slot_info(panel, row, column)
						love.graphics.draw(panel.highlight_sprite, s.x, s.y)
					end
				end

				-- Selected slot
				if panel.selected_slot then
					local row, column = unpack(panel.selected_slot)
					local info = slot_info(panel, row, column)
					love.graphics.draw(panel.selected_sprite, info.x, info.y)
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

	this.toggle = function(panel_name, property)
		if panel_name == 'trash' then
			trash.hidden = not trash.hidden
		else
			property = property or 'hidden'
			panels[panel_name][property] = not panels[panel_name][property]
		end
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
			elseif panel.slots[row][column] == this.EMPTY then
				panel.slots[row][column] = items[1]
				return add_item(tablex.sub(items, 2), row, column)

			-- Case 2: Slot does not contain a matching item
			elseif panel.slots[row][column].name ~= items[1].name then
				row, column = nil, nil
				if try_other_slots then 
					row, column = next()
				end
				return add_item(items, row, column)

			-- Case 3: Slot is full
			elseif panel.slots[row][column].amount == panel.slots[row][column].stack_size then
				row, column = nil, nil
				if try_other_slots then 
					row, column = next()
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

	this.find = function(name, panel)
		for row, column, slot in array2d.iter(panel.slots, true) do
			if slot.name == name then
				return { row, column, slot }
			end
		end
		return nil
	end

	return this
end
