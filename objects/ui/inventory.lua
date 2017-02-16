return function()
	local this = {}

	-- Dependencies

	local array2d = array2d or require 'pl.array2d'
	local tablex = tablex or require 'pl.tablex'

	-- Constants

	this.EMPTY = 'empty'

	-- Input

	local mouse = {}
	local keyboard = {}

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

	function this.add_panel(new_panel)
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

		for index, _ in pairs(defaults) do
			if new_panel[index] == nil then
				new_panel[index] = defaults[index]
			end
		end

		new_panel.width, new_panel.height = new_panel.sprite:getDimensions()
		new_panel.slots = array2d.new(new_panel.rows, new_panel.columns, this.EMPTY)
		panels[new_panel.name] = new_panel
	end

	-- Initialise

	this.initialise = function(signal, _trash_sprite)

		-- Trash
		if _trash_sprite then
			trash = {}
			trash.hidden = true
			trash.sprite = _trash_sprite
			trash.width, trash.height = _trash_sprite:getDimensions()
		end

		-- Register events
		signal.register('mousereleased', function(button, x, y)

			mouse.left = button == 'left'
			mouse.right = button == 'right'
			keyboard.shift = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')


			-- Get clicked item
			local clicked = {}

			if highlighted_slot then
				clicked.panel, clicked.row, clicked.column = unpack(highlighted_slot)
				if clicked.panel.slots[clicked.row][clicked.column] ~= this.EMPTY then
					clicked.item = tablex.copy(clicked.panel.slots[clicked.row][clicked.column])
				end

				-- Clicked callback
				if clicked.panel.onclick then
					clicked.panel.onclick(clicked)
				end
			end

			-- Drop
			if mouse.left and dragged.item then

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
					clicked.panel.drag_and_drop_enabled and
					clicked.panel.slots[clicked.row][clicked.column].name == dragged.item.name

				local function remove_dragged_item()
					dragged.item = nil
				end

				local function reset_dragged_item()
					dragged.item = this.add_item(dragged.item, dragged.panel.name, dragged.row, dragged.column)
				end

				local function swap_items()
					local temp_item = dragged.item
					dragged.item = clicked.panel.slots[clicked.row][clicked.column]
					clicked.panel.slots[clicked.row][clicked.column] = temp_item
					if dragged.item == this.EMPTY then dragged.item = nil end
				end

				local function add_dragged_item()
					dragged.item = this.add_item(dragged.item, clicked.panel.name, clicked.row, clicked.column, false)
				end

				if dropping_over_trash              then remove_dragged_item()
				elseif dropping_outside_panel       then reset_dragged_item()
				elseif dropping_over_different_item then swap_items()
				elseif dropping_over_same_item      then add_dragged_item() end

			-- Drag
			elseif clicked.panel and clicked.panel.drag_and_drop_enabled then

				local can_drag = clicked.item ~= this.EMPTY

				local function set_dragged_item()
					local amount
					if dragged.item then
						amount = dragged.item.amount
					elseif not dragged.item then 
						dragged = clicked
						amount = 0
					end

					if mouse.left and keyboard.shift then amount = math.ceil(clicked.item.amount / 2)
					elseif mouse.left                then amount = clicked.item.amount
					elseif mouse.right               then amount = amount + 1 end
					dragged.item.amount = amount
				end

				local function clear_dragged_item()
					dragged.item = nil
				end

				local function set_grabbed_position()
					local info = slot_info(clicked.panel, clicked.row, clicked.column)
					dragged.sprite_x = love.mouse.getX() - info.x
					dragged.sprite_y = love.mouse.getY() - info.y
				end

				local function empty_dragged_slot()
					if mouse.left and keyboard.shift then dragged.panel.slots[dragged.row][dragged.column].amount = math.floor(dragged.panel.slots[dragged.row][dragged.column].amount / 2)
					elseif mouse.left                then dragged.panel.slots[dragged.row][dragged.column] = this.EMPTY
					elseif mouse.right               then dragged.panel.slots[dragged.row][dragged.column].amount = dragged.panel.slots[dragged.row][dragged.column].amount - 1 end
					if dragged.panel.slots[dragged.row][dragged.column].amount == 0 then dragged.panel.slots[dragged.row][dragged.column] = this.EMPTY end
				end

				if can_drag then
					set_dragged_item()
					set_grabbed_position()
					empty_dragged_slot()
				else
					clear_dragged_item()
				end
			end
		end)
	end

	-- Update

	this.update = function()

		-- Reset
		highlighted_slot = nil

		-- Mouse position
		mouse.x = love.mouse.getX()
		mouse.y = love.mouse.getY()

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
	end

	-- Draw

	this.draw = function()

		local function should_draw_trash()
			return trash and not trash.hidden
		end

		local function should_draw_panels()
			return true
		end

		local function draw_trash()
			love.graphics.draw(trash.sprite, trash.x, trash.y)
		end

		local function draw_panels()
			for _, panel in pairs(panels) do

				local function should_draw_panel()
					return not panel.hidden
				end

				local function should_draw_slots()
					return not panel.hidden
				end

				local function should_draw_highlighted_slot()
					return (not panel.hidden) and highlighted_slot
				end

				local function should_draw_selected_slot()
					return (not panel.hidden) and panel.selected_slot
				end

				local function should_draw_dragged_item()
					return not panel.hidden and dragged.item
				end

				local function draw_panel()
					love.graphics.draw(panel.sprite, panel.x, panel.y)
				end

				local function draw_highlighted_slot()
					local highlighted_panel, row, column = unpack(highlighted_slot)

					local function should_draw()
						return highlighted_panel.name == panel.name
					end

					local function draw()
						local info = slot_info(panel, row, column)
						love.graphics.draw(panel.highlight_sprite, info.x, info.y)
					end

					if should_draw() then draw() end
				end

				local function draw_selected_slot()
					local row, column = unpack(panel.selected_slot)
					local info = slot_info(panel, row, column)
					love.graphics.draw(panel.selected_sprite, info.x, info.y)
				end

				local function draw_dragged_item()
					local x = love.mouse.getX() - dragged.sprite_x
					local y = love.mouse.getY() - dragged.sprite_y
					love.graphics.draw(dragged.item.sprite, x, y)
					love.graphics.setColor(panel.text_color)
					love.graphics.print(dragged.item.amount, x + 2, y)
					love.graphics.setColor(255,255,255,255)
				end

				local function draw_slots()
					for row, column, slot in array2d.iter(panel.slots, true) do

						local function should_draw()
							return slot ~= this.EMPTY
						end

						local function draw()
							local info = slot_info(panel, row, column)
							love.graphics.draw(slot.sprite, info.x, info.y)
							love.graphics.setColor(panel.text_color)
							love.graphics.print(slot.amount, info.x + 2, info.y)
							love.graphics.setColor(255,255,255,255)
						end

						if should_draw() then draw() end
					end
				end

				if should_draw_panel()            then draw_panel()            end
				if should_draw_slots()            then draw_slots()            end
				if should_draw_highlighted_slot() then draw_highlighted_slot() end
				if should_draw_selected_slot()    then draw_selected_slot()    end
				if should_draw_dragged_item()     then draw_dragged_item()     end
			end
		end

		if should_draw_trash()  then draw_trash()  end
		if should_draw_panels() then draw_panels() end
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

	return this
end
