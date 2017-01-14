local plugin = {}
local pluginData = {}

function plugin.initialise()
	pluginData.x = 0
	pluginData.y = 0
	pluginData.width = data.screenWidth
	pluginData.height = data.screenHeight
end

function plugin.update()
	local player = data.plugins.player
	if player then
		local pd = player.getPluginData()
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

return plugin
