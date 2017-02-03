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
	player.initialise()

	flowers = {
		managers.objects.objects.plants.flower_1(30, 10),
	}
	tablex.foreach(flowers, function(flower)
		flower.initialise()
	end)

	background = {
		managers.objects.objects.plants.grass(0, 0),
	}

	foreground = tablex.insertvalues({ player }, flowers)
end

this.update = function(dt)
	managers.time.update(dt)
	managers.viewport.update(this, player)
	player.update(dt)
	tablex.foreach(flowers, function(flower)
		flower.update()
	end)
end

this.draw = function()
	love.graphics.push()
	love.graphics.translate(-managers.viewport.x, -managers.viewport.y)

	table.sort(foreground, function(a, b) return
		a.y + a.height < b.y + b.height
	end)
	for _, background_object in ipairs(background) do
		love.graphics.draw(background_object.sprite, background_object.x, background_object.y)
	end
	for _, foreground_object in ipairs(foreground) do
		love.graphics.draw(foreground_object.sprite, foreground_object.x, foreground_object.y)
	end

	love.graphics.pop()
end

return this
