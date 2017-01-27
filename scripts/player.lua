local this = {}

this.initialise = function()
	this.vector = data.libraries.vector
	this.x = 0
	this.y = 0
end

-- Public Functions

function this.in_range(target_vector, range)
	range = range or 0
	local distance = (this.get_center - target_vector):len()
	return distance <= range
end

return this
