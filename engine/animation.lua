local plugin = {}
local pluginData = {
	player = {
		move_up = {
			 'player_walk_up_1',
			 'player_walk_up_2',
			 'player_walk_up_3',
			 'player_walk_up_4',
			 'player_walk_up_5',
			 'player_walk_up_6',
			 'player_walk_up_7',
			 'player_walk_up_8'
		},
		move_down = {
			'player_walk_down_1',
			'player_walk_down_2',
			'player_walk_down_3',
			'player_walk_down_4',
			'player_walk_down_5',
			'player_walk_down_6',
			'player_walk_down_7',
			'player_walk_down_8'
		},
		move_left = {
			'player_walk_left_1',
			'player_walk_left_2',
			'player_walk_left_3',
			'player_walk_left_4',
			'player_walk_left_5',
			'player_walk_left_6',
			'player_walk_left_7',
			'player_walk_left_8'
		},
		move_right = {
			'player_walk_right_1',
			'player_walk_right_2',
			'player_walk_right_3',
			'player_walk_right_4',
			'player_walk_right_5',
			'player_walk_right_6',
			'player_walk_right_7',
			'player_walk_right_8'
		},
		idle = {
			'player_walk_down_1'
		}
	}
}

-- Public functions

function plugin.cycle(thing, dt)
	if thing.id == 'player' then

		-- Initialise data

		thing.frameCounter = thing.frameCounter or 0
		thing.timeSinceLastFrame = thing.timeSinceLastFrame or 0

		-- Maintain time since last player animation update

		thing.timeSinceLastFrame = thing.timeSinceLastFrame + dt

		-- Cycle the frames

		if thing.timeSinceLastFrame > 1 / thing.framesPerSecond then
			thing.timeSinceLastFrame = 0
			thing.frameCounter = thing.frameCounter + 1
			if thing.frameCounter > table.getn(pluginData[thing.id][thing.animationState]) then
				thing.frameCounter = 1
			end

			-- Set the current sprite

			local sprites = data.plugins.sprites
			local spriteId = pluginData
				[thing.id]
				[thing.animationState]
				[thing.frameCounter]

			thing.sprite = sprites.getSprite(spriteId)
		end
	end
end

return plugin
