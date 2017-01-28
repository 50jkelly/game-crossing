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
	local player_center = geometry.get_center(player_position)
	local viewport_center = geometry.get_center(this)

	call_hook('plugins', 'viewport_updated', {
		x = (player_center + viewport_center).x,
		y = (player_center + viewport_center).y,
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
