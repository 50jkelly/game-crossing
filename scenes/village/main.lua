local this = {}

this.width = 2560
this.height = 2560
local managers
local background
local foreground
local player
local inventory

-- Initialisation

this.initialise = function(_managers)
	managers = _managers
	world = bump.newWorld()
	player = managers.objects.objects.player(10, 10)
	inventory = managers.objects.objects.ui.inventory()

	foreground = {
		player,
		managers.objects.objects.plants.flower_1(world, 50, 50),
	}

	background = {
		managers.objects.objects.plants.grass(0, 0),
	}

	ui = {
		managers.objects.objects.ui.progress_bar(0, 0),
		inventory,
		managers.objects.objects.ui.cursor_1(world),
	}

	initialise_all(foreground)
	initialise_all(ui)

	-- Removal

	signal.register('remove_object', function(object)
		table.remove(foreground, tablex.find(foreground, object))
	end)

	inventory.add(managers.items.items.stack(1, managers.graphics.graphics.items.seed)) end

-- Update

this.update = function(dt)
	managers.time.update(dt)
	managers.viewport.update(this, player)
	update_all(foreground, dt)
	update_all(ui, { foreground, dt })
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

	draw_all(ui)
end

return this
