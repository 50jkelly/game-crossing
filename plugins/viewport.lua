local this = {}
local geometry
local vector

this.initialise = function()
	geometry = data.libraries.geometry
	vector = data.libraries.vector
	this.x = 0
	this.y = 0
	this.width = love.graphics.getWidth()
	this.height = love.graphics.getHeight()
	call_hook('plugins', 'viewport_updated', this)
end

this.set_dimensions = function(width, height)
	this.width = width
	this.height = height
	call_hook('plugins', 'viewport_updated', this)
end

this.player_position_updated = function(player_position)
	local player_center = geometry.get_center(player_position)
	local viewport_center = vector(this.width, this.height) / 2

	call_hook('plugins', 'viewport_updated', {
		x = (player_center - viewport_center).x,
		y = (player_center - viewport_center).y,
		width = this.width,
		height = this.height,
		center = viewport_center,
	})
end

return this
