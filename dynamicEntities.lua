local plugin = {}
local pluginData = {}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/dynamicEntities.lua')
	callHook('plugins', 'dynamicEntitiesLoaded')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/dynamicEntities.lua')
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

return plugin
