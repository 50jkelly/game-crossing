local this = {}

this.initialise = function(managers)
	this.animations = {
		player = {
			walk_down = function(fps, initial_frame)
				return {
					fps = fps,
					current_frame = initial_frame or 1,
					time_since_last_frame = 0,
					frames = {
						managers.graphics.graphics.player.player_walk_down_1,
						managers.graphics.graphics.player.player_walk_down_2,
						managers.graphics.graphics.player.player_walk_down_3,
						managers.graphics.graphics.player.player_walk_down_4,
						managers.graphics.graphics.player.player_walk_down_5,
						managers.graphics.graphics.player.player_walk_down_6,
						managers.graphics.graphics.player.player_walk_down_7,
						managers.graphics.graphics.player.player_walk_down_8,
					},
				}
			end,
			walk_left = function(fps, initial_frame)
				return {
					fps = fps,
					current_frame = initial_frame or 1,
					time_since_last_frame = 0,
					frames = {
						managers.graphics.graphics.player.player_walk_left_1,
						managers.graphics.graphics.player.player_walk_left_2,
						managers.graphics.graphics.player.player_walk_left_3,
						managers.graphics.graphics.player.player_walk_left_4,
						managers.graphics.graphics.player.player_walk_left_5,
						managers.graphics.graphics.player.player_walk_left_6,
						managers.graphics.graphics.player.player_walk_left_7,
						managers.graphics.graphics.player.player_walk_left_8,
					},
				}
			end,
			walk_right = function(fps, initial_frame)
				return {
					fps = fps,
					current_frame = initial_frame or 1,
					time_since_last_frame = 0,
					frames = {
						managers.graphics.graphics.player.player_walk_right_1,
						managers.graphics.graphics.player.player_walk_right_2,
						managers.graphics.graphics.player.player_walk_right_3,
						managers.graphics.graphics.player.player_walk_right_4,
						managers.graphics.graphics.player.player_walk_right_5,
						managers.graphics.graphics.player.player_walk_right_6,
						managers.graphics.graphics.player.player_walk_right_7,
						managers.graphics.graphics.player.player_walk_right_8,
					},
				}
			end,
			walk_up = function(fps, initial_frame)
				return {
					fps = fps,
					current_frame = initial_frame or 1,
					time_since_last_frame = 0,
					frames = {
						managers.graphics.graphics.player.player_walk_up_1,
						managers.graphics.graphics.player.player_walk_up_2,
						managers.graphics.graphics.player.player_walk_up_3,
						managers.graphics.graphics.player.player_walk_up_4,
						managers.graphics.graphics.player.player_walk_up_5,
						managers.graphics.graphics.player.player_walk_up_6,
						managers.graphics.graphics.player.player_walk_up_7,
						managers.graphics.graphics.player.player_walk_up_8,
					},
				}
			end,
		}
	}
end

this.next_frame = function(animation, dt)
	animation.time_since_last_frame = animation.time_since_last_frame + dt
	while animation.time_since_last_frame > 1 / animation.fps do
		animation.current_frame = animation.current_frame + 1
		if animation.current_frame > #animation.frames then
			animation.current_frame = 1
		end
		animation.time_since_last_frame = animation.time_since_last_frame - 1 / animation.fps
	end
	return animation.frames[animation.current_frame]
end

this.reset = function(animation)
	animation.current_frame = 1
	return animation.frames[animation.current_frame]
end

return this
