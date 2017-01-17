local plugin = {}
local pluginData = {}

-- Hooks

function plugin.initialise()
	pluginData.x = 0
	pluginData.y = 0
	pluginData.width = 800
	pluginData.height = 600
end

function plugin.update()
	local things = data.plugins.things
	if things then
		local pd = things.getThing('player')
		pluginData.x = pd.x - (pluginData.width / 2) + pd.width + pd.drawXOffset
		pluginData.y = pd.y - (pluginData.height / 2) + pd.height + pd.drawYOffset
	end
end

function plugin.preDraw()
	love.graphics.push()
	love.graphics.translate(-pluginData.x, -pluginData.y)
end

function plugin.postDraw()
	love.graphics.pop()
end

function love.resize(width, height)
	pluginData.width = width
	pluginData.height = height
end

-- Functions

function plugin.getPluginData()
	return pluginData
end

return plugin
