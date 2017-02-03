local this = {}

this.width = 2560
this.height = 2560
local managers
local background
local foreground
local player

this.initialise = function(_managers)
	managers = _managers
	player = managers.objects.objects.player(10, 10)

	foreground = {
		player,
		managers.objects.objects.plants.flower_1(30, 20),
	}

	background = {
		managers.objects.objects.plants.grass(0, 0),
	}

	initialise_all(foreground)
end

this.update = function(dt)
	managers.time.update(dt)
	managers.viewport.update(this, player)
	update_all(foreground, dt)
end

this.draw = function()
	love.graphics.push()
	love.graphics.translate(-managers.viewport.x, -managers.viewport.y)

	table.sort(foreground, function(a, b)
		return a.y + a.height < b.y + b.height
	end)

	draw_all(background)
	draw_all(foreground)
	love.graphics.pop()
end

return this
