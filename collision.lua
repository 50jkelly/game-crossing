local collision = {}

function collision.initialise()
	for _, entity in ipairs(data.dynamicEntities) do
		entity.collidingWith = {}
	end
end

function collision.update()
	-- Iterate over all items that can move and check if they are colliding with anything
	for _, entity in ipairs(data.dynamicEntities) do
		local entities = {}
		local staticEntities = data.plugins.staticEntities
		if staticEntities then
			entities = concat(staticEntities.getTable(), data.dynamicEntities)
		else
			entities = data.dynamicEntities
		end
		for _, otherEntity in ipairs(entities) do
			if entity.id ~= otherEntity.id and otherEntity.collides then
				if overlapping(entity, otherEntity) then
					entity.collision(otherEntity)
				end
			end
		end
	end
end

-- Private functions

function alreadyColliding(item1, item2)
	for _, item in ipairs(item1.collidingWith) do
		if item.id == item2.id then
			return true
		end
	end
	return false
end

return collision
