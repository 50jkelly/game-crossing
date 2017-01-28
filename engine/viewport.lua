local this = {}

local geometry
local player

function this.initialise()
	geometry = data.libraries.geometry
	player = data.plugins.player

	this.x = 0
	this.y = 0
	this.width = love.graphics.getWidth()
	this.height = love.graphics.getHeight()
end

function this.update()
	if player then
		this.x = geometry.get_center(player).x
		this.y = geometry.get_center(player).y
	end
end

function this.pre_draw()
	love.graphics.push()
	love.graphics.translate(-this.x, -this.y)
end

function this.post_draw()
	love.graphics.pop()
end

return this
