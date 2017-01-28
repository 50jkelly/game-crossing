local this = {}

this.initialise = function()
	this.x = 0
	this.y = 0
	this.width = 20
	this.height = 26
end

this.update = function()
	call_hook('plugins', 'player_position_updated', {
		x = this.x,
		y = this.y,
		width = this.width,
		height = this.height
	})
end

-- Public Functions

function this.in_range(target_vector, range)
	range = range or 0
	local distance = (this.get_center - target_vector):len()
	return distance <= range
end

return this
