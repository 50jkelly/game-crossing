local this = {}

function this.rectangle(entity)
	if is_rectangle(entity) then
		return {
			x = entity.x,
			y = entity.y,
			width = entity.width,
			height = entity.height,
		}
	end

	return false
end

function this.get_center()
	if is_rectangle(entity) then
		local center_x = entity.x + entity.width / 2
		local center_y = entity.y + entity.height / 2
		return vector(center_x, center_y)
	end
	return false
end

local is_rectangle = function(entity)
	return
		entity.x and
		entity.y and
		entity.width and
		entity.height
end

return this
