local plugin = {}
local pluginData
local playerOverlapping

-- Hooks

function plugin.loadGame()
	pluginData = data.plugins.persistence.read('saves/plants.lua')
end

function plugin.saveGame()
	data.plugins.persistence.write(pluginData, 'saves/plants.lua')
end

function plugin.staticEntitiesLoaded(staticEntities)
	if not pluginData then plugin.loadGame() end

	-- Add a suitable entry for each plant in the static entities table

	for id, plant in pairs(pluginData) do
		local staticEntityId = getNextFreeId(staticEntities, 'plant')
		staticEntities[staticEntityId] = {
			collides = false,
			x = plant.x,
			y = plant.y,
			width = plant.width,
			height = plant.height,
			spriteId = plant.sprite
		}
	end
end

function plugin.triggersLoaded(triggers)
	if not pluginData then plugin.loadGame() end

	for id, plant in pairs(pluginData) do

		-- Add a trigger for each plant to tell the player that they are overlapping a plant

		local triggerId = getNextFreeId(triggers, 'trigger')
		triggers[triggerId] = {
			x = plant.x,
			y = plant.y,
			width = plant.width,
			height = plant.height,
			triggerHook = 'overlappingPlant',
			data = {
				plantId = id,
				plantName = plant.name
			}
		}
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

return plugin
