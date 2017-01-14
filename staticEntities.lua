local plugin = {}
local pluginData = {}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/staticEntities.lua')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/staticEntities.lua')
end

function plugin.itemPickupFire(triggerData)
	pluginData[triggerData.entity] = nil
end

function plugin.itemDrop(itemData)

	-- Add the item's data to the static entities data

	pluginData[itemData.staticEntityId] = {
		collides = false,
		x = itemData.item.x,
		y = itemData.item.y,
		width = 25,
		height = 25,
		drawXOffset = 0,
		drawYOffset = 0,
		spriteId = itemData.item.sprite,
		scale = 0.5
	}
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

return plugin
