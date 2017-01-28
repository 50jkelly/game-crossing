local this = {}

local movements = {
	up = function(entity, dt)
		return entity.x, entity.y - entity.speed * dt
	end,

	down = function(entity, dt)
		return entity.x, entity.y + entity.speed * dt
	end,

	left = function(entity, dt)
		return entity.x - entity.speed * dt, entity.y
	end,

	right = function(entity, dt)
		return entity.x + entity.speed * dt, entity.y
	end,
}

this.move = function(entity, direction, dt)
	if movements[direction] then
		entity.x, entity.y = movements[direction](entity, dt)
	end
end

return this
