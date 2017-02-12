local this = {}

this.width = 2560
this.height = 2560
local managers
local background
local foreground
local player
local progress_bar
local cursor
local tooltip

-- Initialisation

this.initialise = function(_managers)
	managers = _managers
	world = bump.newWorld()
	player = managers.objects.objects.player(10, 10)

	foreground = {
		player,
		managers.objects.objects.plants.flower_1(world, 50, 50),
	}

	background = {
		managers.objects.objects.plants.grass(0, 0),
	}

	progress_bar = managers.objects.objects.ui.progress_bar(0, 0)
	tooltip = tooltip_library.new()
	cursor = managers.objects.objects.ui.cursor_1(world)

	initialise_all(foreground)

	progress_bar.initialise()
	cursor.initialise()

	-- Removal

	signal.register('remove_object', function(object)
		table.remove(foreground, tablex.find(foreground, object))
	end)

	-- Inventory

	inventory.add_panel({
		name = 'main',
		sprite = managers.graphics.graphics.ui.inventory.inventory_20,
		highlight_sprite = managers.graphics.graphics.ui.inventory.inventory_slot_highlight,
		hidden = true,
		rows = 2,
		position = function(panel)
			panel.x = (love.graphics.getWidth() - panel.width) / 2
			panel.y = (love.graphics.getHeight() - panel.height) / 2
		end,
	})

	inventory.add_panel({
		name = 'action_bar',
		sprite = managers.graphics.graphics.ui.inventory.action_bar_10,
		highlight_sprite = managers.graphics.graphics.ui.inventory.inventory_slot_highlight,
		hidden = false,
		drag_and_drop_enabled = false,
		position = function(panel)
			panel.x = (love.graphics.getWidth() - panel.width) / 2
			panel.y = love.graphics.getHeight() - panel.height - 20
		end,
	})

	signal.register('keypressed', function(key)
		if key == 'inventory' then
			inventory.toggle('main')
			inventory.toggle('trash')
		end
	end)

	inventory.add_item({
		name = 'Seeds',
		sprite = managers.graphics.graphics.items.seed,
		amount = 3,
		stack_size = 4
	}, 'main', 2, 1)
	inventory.add_item({
		name = 'Seeds',
		sprite = managers.graphics.graphics.items.seed,
		amount = 2,
		stack_size = 4
	}, 'main', 2, 2)
	inventory.add_item({
		name = 'Books',
		sprite = managers.graphics.graphics.items.book,
		amount = 1,
	}, 'action_bar')

end

-- Update

this.update = function(dt)
	managers.time.update(dt)
	managers.viewport.update(this, player)
	update_all(foreground, dt)

	tooltip.update(dt)
	inventory.update()
	cursor.update({foregorund, dt})
end

-- Drawing

this.draw = function()
	love.graphics.push()
	love.graphics.translate(-managers.viewport.x, -managers.viewport.y)

	table.sort(foreground, function(a, b)
		return a.y + a.height < b.y + b.height
	end)

	draw_all(background)
	draw_all(foreground)

	love.graphics.pop()

	progress_bar.draw()
	inventory.draw()
	tooltip.draw()
	cursor.draw()
end

return this
