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

function this.rectangle()
	local can_make_rectangle = 
		this.x and
		this.y and
		this.width and
		this.height

	if can_make_rectangle then
		return {
			x = this.x,
			y = this.y,
			width = this.width,
			height = this.height,
		}
	end

	return false
end

function this.get_center()
	local center_x = this.x + this.width / 2
	local center_y = this.y + this.height / 2
	return vector(center_x, center_y)
end

return this
