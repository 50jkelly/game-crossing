local plugin = {}

-- Hooks

function plugin.update()

	-- Merge the dynamic and static entities tables

	local dynamicEntities = data.plugins.dynamicEntities
	local staticEntities = data.plugins.staticEntities
	local entities = {}

	if dynamicEntities then
		for i, v in pairs(dynamicEntities.getPluginData()) do
			entities[i] = v
		end
	end

	if staticEntities then
		for i, v in pairs(staticEntities.getPluginData()) do
			entities[i] = v
		end
	end

	-- Iterate over all items that can move and check if they are colliding with anything

	for id, entity in pairs(dynamicEntities.getPluginData()) do
		entity.colliding = false
		for otherId, otherEntity in pairs(entities) do
			if id ~= otherId and otherEntity.collides then
				if overlapping(entity, otherEntity) then
					entity.colliding = true
					callHook('plugins', 'collision')
				end
			end
		end
	end
end

return plugin
