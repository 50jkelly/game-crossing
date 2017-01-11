local animation = {}

function animation.assetsLoaded()
	local player = data.player
	if player then
		player.walk_down_1_sprite = 'player_walk_down_1'
		player.walk_down_2_sprite = 'player_walk_down_2'
		player.walk_down_3_sprite = 'player_walk_down_3'
		player.walk_down_4_sprite = 'player_walk_down_4'
		player.walk_down_5_sprite = 'player_walk_down_5'
		player.walk_down_6_sprite = 'player_walk_down_6'
		player.walk_down_7_sprite = 'player_walk_down_7'
		player.walk_down_8_sprite = 'player_walk_down_8'
		player.walk_left_1_sprite = 'player_walk_left_1'
		player.walk_left_2_sprite = 'player_walk_left_2'
		player.walk_left_3_sprite = 'player_walk_left_3'
		player.walk_left_4_sprite = 'player_walk_left_4'
		player.walk_left_5_sprite = 'player_walk_left_5'
		player.walk_left_6_sprite = 'player_walk_left_6'
		player.walk_left_7_sprite = 'player_walk_left_7'
		player.walk_left_8_sprite = 'player_walk_left_8'
		player.walk_right_1_sprite = 'player_walk_right_1'
		player.walk_right_2_sprite = 'player_walk_right_2'
		player.walk_right_3_sprite = 'player_walk_right_3'
		player.walk_right_4_sprite = 'player_walk_right_4'
		player.walk_right_5_sprite = 'player_walk_right_5'
		player.walk_right_6_sprite = 'player_walk_right_6'
		player.walk_right_7_sprite = 'player_walk_right_7'
		player.walk_right_8_sprite = 'player_walk_right_8'
		player.walk_up_1_sprite = 'player_walk_up_1'
		player.walk_up_2_sprite = 'player_walk_up_2'
		player.walk_up_3_sprite = 'player_walk_up_3'
		player.walk_up_4_sprite = 'player_walk_up_4'
		player.walk_up_5_sprite = 'player_walk_up_5'
		player.walk_up_6_sprite = 'player_walk_up_6'
		player.walk_up_7_sprite = 'player_walk_up_7'
		player.walk_up_8_sprite = 'player_walk_up_8'
	end
end

function animation.update()
	local entities = concat(data.staticEntities, data.dynamicEntities)
	for _, entity in ipairs(entities) do
		if entity.resetAnimation then
			reset(entity)
		elseif entity.cycleAnimation then
			cycleFrames(entity, data)
		end
		entity.resetAnimation = false
		entity.cycleAnimation = false
	end
end

function reset(entity)
	if entity.id == 'player' then
		local player = data.player
		if entity.state == 'walk_up' then entity.spriteId = player.walk_up_1_sprite
		elseif entity.state == 'walk_down' then entity.spriteId = player.walk_down_1_sprite
		elseif entity.state == 'walk_left' then entity.spriteId = player.walk_left_1_sprite
		elseif entity.state == 'walk_right' then entity.spriteId = player.walk_right_1_sprite
		else entity.spriteId = player.walk_down_1.sprite end
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
		entity.spriteId = entity[spriteId]
	end
end

return animation
