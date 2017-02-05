local this = {}

this.load = function()
	this.graphics = {
		items = {
			book = love.graphics.newImage('graphics/items/book.png'),
			jug = love.graphics.newImage('graphics/items/jug.png'),
			seed = love.graphics.newImage('graphics/items/seed.png'),
		},
		light_maps = {
			flower_1 = love.graphics.newImage('graphics/light_maps/flower_1.png'),
			player = love.graphics.newImage('graphics/light_maps/player.png'),
		},
		light_masks = {
			tree_1_top = love.graphics.newImage('graphics/light_masks/tree_1_top.png'),
		},
		misc = {
			none = love.graphics.newImage('graphics/misc/none.png')
		},
		plants = {
			flower_1 = love.graphics.newImage('graphics/plants/flower_1.png'),
			flower_1_start = love.graphics.newImage('graphics/plants/flower_1_start.png'),
			grass = love.graphics.newImage('graphics/plants/grass.png'),
		},
		player = {
			player_walk_down_1 = love.graphics.newImage('graphics/player/player_walk_down_1.png'),
			player_walk_down_2 = love.graphics.newImage('graphics/player/player_walk_down_2.png'),
			player_walk_down_3 = love.graphics.newImage('graphics/player/player_walk_down_3.png'),
			player_walk_down_4 = love.graphics.newImage('graphics/player/player_walk_down_4.png'),
			player_walk_down_5 = love.graphics.newImage('graphics/player/player_walk_down_5.png'),
			player_walk_down_6 = love.graphics.newImage('graphics/player/player_walk_down_6.png'),
			player_walk_down_7 = love.graphics.newImage('graphics/player/player_walk_down_7.png'),
			player_walk_down_8 = love.graphics.newImage('graphics/player/player_walk_down_8.png'),
			player_walk_left_1 = love.graphics.newImage('graphics/player/player_walk_left_1.png'),
			player_walk_left_2 = love.graphics.newImage('graphics/player/player_walk_left_2.png'),
			player_walk_left_3 = love.graphics.newImage('graphics/player/player_walk_left_3.png'),
			player_walk_left_4 = love.graphics.newImage('graphics/player/player_walk_left_4.png'),
			player_walk_left_5 = love.graphics.newImage('graphics/player/player_walk_left_5.png'),
			player_walk_left_6 = love.graphics.newImage('graphics/player/player_walk_left_6.png'),
			player_walk_left_7 = love.graphics.newImage('graphics/player/player_walk_left_7.png'),
			player_walk_left_8 = love.graphics.newImage('graphics/player/player_walk_left_8.png'),
			player_walk_right_1 = love.graphics.newImage('graphics/player/player_walk_right_1.png'),
			player_walk_right_2 = love.graphics.newImage('graphics/player/player_walk_right_2.png'),
			player_walk_right_3 = love.graphics.newImage('graphics/player/player_walk_right_3.png'),
			player_walk_right_4 = love.graphics.newImage('graphics/player/player_walk_right_4.png'),
			player_walk_right_5 = love.graphics.newImage('graphics/player/player_walk_right_5.png'),
			player_walk_right_6 = love.graphics.newImage('graphics/player/player_walk_right_6.png'),
			player_walk_right_7 = love.graphics.newImage('graphics/player/player_walk_right_7.png'),
			player_walk_right_8 = love.graphics.newImage('graphics/player/player_walk_right_8.png'),
			player_walk_up_1 = love.graphics.newImage('graphics/player/player_walk_up_1.png'),
			player_walk_up_2 = love.graphics.newImage('graphics/player/player_walk_up_2.png'),
			player_walk_up_3 = love.graphics.newImage('graphics/player/player_walk_up_3.png'),
			player_walk_up_4 = love.graphics.newImage('graphics/player/player_walk_up_4.png'),
			player_walk_up_5 = love.graphics.newImage('graphics/player/player_walk_up_5.png'),
			player_walk_up_6 = love.graphics.newImage('graphics/player/player_walk_up_6.png'),
			player_walk_up_7 = love.graphics.newImage('graphics/player/player_walk_up_7.png'),
			player_walk_up_8 = love.graphics.newImage('graphics/player/player_walk_up_8.png'),
		},
		trees = {
			tree_1_bottom = love.graphics.newImage('graphics/trees/tree_1_bottom.png'),
			tree_1_top = love.graphics.newImage('graphics/trees/tree_1_top.png'),
		},
		ui = {
			cursor_1 = love.graphics.newImage('graphics/ui/cursor_1.png'),
			cursor_2 = love.graphics.newImage('graphics/ui/cursor_2.png'),
			progress_bar = {
				progress_bar_1 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_1.png'),
				progress_bar_2 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_2.png'),
				progress_bar_3 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_3.png'),
				progress_bar_4 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_4.png'),
				progress_bar_5 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_5.png'),
				progress_bar_6 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_6.png'),
				progress_bar_7 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_7.png'),
				progress_bar_8 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_8.png'),
				progress_bar_9 = love.graphics.newImage('graphics/ui/progress_bar/progress_bar_9.png'),
			},
		},
	}
end


return this
