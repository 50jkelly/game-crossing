local this = {}

local frames = {
	player_walk_up = {
		'player_walk_up_1',
		'player_walk_up_2',
		'player_walk_up_3',
		'player_walk_up_4',
		'player_walk_up_5',
		'player_walk_up_6',
		'player_walk_up_7',
		'player_walk_up_8',
	},
	player_walk_down = {
		'player_walk_down_1',
		'player_walk_down_2',
		'player_walk_down_3',
		'player_walk_down_4',
		'player_walk_down_5',
		'player_walk_down_6',
		'player_walk_down_7',
		'player_walk_down_8',
	},
	player_walk_left = {
		'player_walk_left_1',
		'player_walk_left_2',
		'player_walk_left_3',
		'player_walk_left_4',
		'player_walk_left_5',
		'player_walk_left_6',
		'player_walk_left_7',
		'player_walk_left_8',
	},
	player_walk_right = {
		'player_walk_right_1',
		'player_walk_right_2',
		'player_walk_right_3',
		'player_walk_right_4',
		'player_walk_right_5',
		'player_walk_right_6',
		'player_walk_right_7',
		'player_walk_right_8',
	},
}

this.enable_animation = function(entity)
	entity.frame_counter = entity.frame_counter or 1
	entity.time_elapsed = entity.time_elapsed or 0
	entity.frames_per_second = entity.frames_per_second or 1
	entity.cycle = entity.cycle or true
end

this.continue_animation = function(data)
	local time_elapsed = data.entity.time_elapsed
	local frames_per_second = data.entity.frames_per_second
	local frame_counter = data.entity.frame_counter
	local animation_state = data.entity.animation_state
	local sprite = data.entity.sprite

	if time_elapsed > 1 / frames_per_second then
		time_elapsed = 0
		frame_counter = frame_counter + 1
		if frame_counter > #frames[animation_state] then
			frame_counter = 1
		end

		sprite = frames[animation_state][frame_counter]
	end

	if not sprite then
		sprite = frames[animation_state][1]
	end

	data.entity.time_elapsed = time_elapsed
	data.entity.frame_counter = frame_counter
	data.entity.sprite = sprite
end

return this
