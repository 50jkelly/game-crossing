local plugin = {}
local pluginData = {}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
end

function plugin.loadGame()
	pluginData = data.plugins.persistence.read('saves/items.lua')
end

function plugin.saveGame()
	data.plugins.persistence.write(pluginData, 'saves/items.lua')
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

return plugin
