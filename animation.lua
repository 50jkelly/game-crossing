local plugin = {}
local pluginData = {}

-- Hooks

function plugin.initialise()
	plugin.loadGame()
end

function plugin.loadGame()
	pluginData = data.plugins.saveLoad.read('saves/animations.lua')
end

function plugin.saveGame()
	data.plugins.saveLoad.write(pluginData, 'saves/animations.lua')
end

function plugin.update()
	local dynamicEntities = data.plugins.dynamicEntities
	if dynamicEntities then
		for _, entity in pairs(dynamicEntities.getPluginData()) do
			if entity.resetAnimation then
				reset(entity)
			elseif entity.cycleAnimation then
				cycleFrames(entity)
			end
			entity.resetAnimation = false
			entity.cycleAnimation = false
		end
	end
end

-- Public functions

function plugin.getPluginData()
	return pluginData
end

-- Private functions

function reset(entity)
	if entity.id == 'player' then
		local walkUpSprite = pluginData.player.walk_up_1_sprite
		local walkDownSprite = pluginData.player.walk_down_1_sprite
		local walkLeftSprite = pluginData.player.walk_left_1_sprite
		local walkRightSprite = pluginData.player.walk_right_1_sprite

		if entity.state == 'walk_up' then entity.spriteId = walkUpSprite
		elseif entity.state == 'walk_down' then entity.spriteId = walkDownSprite
		elseif entity.state == 'walk_left' then entity.spriteId = walkLeftSprite
		elseif entity.state == 'walk_right' then entity.spriteId = walkRightSprite
		else entity.spriteId = walkDownSprite end
	end
end

function cycleFrames(entity)
	if entity.id == 'player' then

		-- Maintain time since last player animation update
		entity.timeSinceLastFrame = entity.timeSinceLastFrame + data.dt

		-- Cycle the frames
		if entity.timeSinceLastFrame > 1 / entity.framesPerSecond then
			entity.timeSinceLastFrame = 0
			entity.frameCounter = entity.frameCounter + 1
			if entity.frameCounter > 8 then
				entity.frameCounter = 1
			end
		end

		-- Set the current sprite
		local spriteId = entity.state .. '_' .. entity.frameCounter .. '_sprite'
		entity.spriteId = pluginData.player[spriteId]
	end
end

return plugin
