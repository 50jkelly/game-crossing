local this = {}
local geometry

this.initialise = function()
	geometry = data.libraries.geometry
	this.x = 0
	this.y = 0
	this.width = love.graphics.getWidth()
	this.height = love.graphics.getHeight()
end

this.player_position_updated = function(player_position)
	this.x = geometry.get_center(player_position).x
	this.y = geometry.get_center(player_position).y
	call_hook('viewport_updated', {
		x = this.x,
		y = this.y,
		width = this.width,
		height = this.height,
	})
end

function this.pre_draw()
	love.graphics.push()
	love.graphics.translate(-this.x, -this.y)
end

function this.post_draw()
	love.graphics.pop()
end

return this
