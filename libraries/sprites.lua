local this = {}
local sprites ={}

local load_sprite = function(name, path)
	local sprite = love.graphics.newImage(path)
	local width, height = sprite:getDimensions()

	sprites[name] = {
		sprite = sprite,
		width = width,
		height = height
	}
end

function this.load_graphics()

	-- Player animations

	load_sprite('player_walk_up_1', 'images/player_walk_up_1.png')
	load_sprite('player_walk_up_2', 'images/player_walk_up_2.png')
	load_sprite('player_walk_up_3', 'images/player_walk_up_3.png')
	load_sprite('player_walk_up_4', 'images/player_walk_up_4.png')
	load_sprite('player_walk_up_5', 'images/player_walk_up_5.png')
	load_sprite('player_walk_up_6', 'images/player_walk_up_6.png')
	load_sprite('player_walk_up_7', 'images/player_walk_up_7.png')
	load_sprite('player_walk_up_8', 'images/player_walk_up_8.png')

	load_sprite('player_walk_down_1', 'images/player_walk_down_1.png')
	load_sprite('player_walk_down_2', 'images/player_walk_down_2.png')
	load_sprite('player_walk_down_3', 'images/player_walk_down_3.png')
	load_sprite('player_walk_down_4', 'images/player_walk_down_4.png')
	load_sprite('player_walk_down_5', 'images/player_walk_down_5.png')
	load_sprite('player_walk_down_6', 'images/player_walk_down_6.png')
	load_sprite('player_walk_down_7', 'images/player_walk_down_7.png')
	load_sprite('player_walk_down_8', 'images/player_walk_down_8.png')

	load_sprite('player_walk_left_1', 'images/player_walk_left_1.png')
	load_sprite('player_walk_left_2', 'images/player_walk_left_2.png')
	load_sprite('player_walk_left_3', 'images/player_walk_left_3.png')
	load_sprite('player_walk_left_4', 'images/player_walk_left_4.png')
	load_sprite('player_walk_left_5', 'images/player_walk_left_5.png')
	load_sprite('player_walk_left_6', 'images/player_walk_left_6.png')
	load_sprite('player_walk_left_7', 'images/player_walk_left_7.png')
	load_sprite('player_walk_left_8', 'images/player_walk_left_8.png')

	load_sprite('player_walk_right_1', 'images/player_walk_right_1.png')
	load_sprite('player_walk_right_2', 'images/player_walk_right_2.png')
	load_sprite('player_walk_right_3', 'images/player_walk_right_3.png')
	load_sprite('player_walk_right_4', 'images/player_walk_right_4.png')
	load_sprite('player_walk_right_5', 'images/player_walk_right_5.png')
	load_sprite('player_walk_right_6', 'images/player_walk_right_6.png')
	load_sprite('player_walk_right_7', 'images/player_walk_right_7.png')
	load_sprite('player_walk_right_8', 'images/player_walk_right_8.png')

	-- Plants

	load_sprite('grass', 'images/grass.png')
end

function this.get_sprite(name)
	return sprites[name]
end

return this
