local get_player_range = function(player)
	x = player.x + player.width / 2 - player.range / 2
	y = player.y + player.height / 2 - player.range / 2
	return x, y
end

return {
	new = function(managers, x, y)
		local player = {}

		-- Basic

		player.x = x
		player.y = y
		player.speed = 100
		player.width = 20
		player.height = 26

		-- Interaction range

		player.range = 100
		player.range_object = { player_range = true }

		-- Animation

		player.animations = {
			walk_up = managers.animations.animations.player.walk_up(10),
			walk_down = managers.animations.animations.player.walk_down(10),
			walk_left = managers.animations.animations.player.walk_left(10),
			walk_right = managers.animations.animations.player.walk_right(10),
		}
		player.current_animation = player.animations.walk_down
		player.animation_status = 'reset'
		player.sprite = player.current_animation.frames[player.current_animation.current_frame]

		-- Movement

		player.directions = {
			up = function(dt) player.y = player.y - player.speed * dt end,
			down = function(dt) player.y = player.y + player.speed * dt end,
			left = function(dt) player.x = player.x - player.speed * dt end,
			right = function(dt) player.x = player.x + player.speed * dt end,
			idle = function() end,
		}
		player.current_direction = 'idle'

		-- Initialisation

		player.initialise = function()

			-- Keyboard input

			signal.register('keypressed', function(key)
				if player.directions[key] then 
					if key ~= player.current_direction then
						player.current_direction = key
						player.current_animation = player.animations['walk_'..key]
					end
					player.animation_status = 'next_frame'
				end
			end)

			signal.register('keyreleased', function(key)
				if player.current_direction == key then
					player.current_direction = 'idle'
					player.animation_status = 'reset'
				end
			end)

			-- Mouse input

			signal.register('mousepressed', function(button, x, y)
				if button == 'left' then
					print(x, y)
				end
				if button == 'right' then
					print('hello')
				end
			end)

			-- Interaction range

			local player_range_x, player_range_y = get_player_range(player)
			world:add(player.range_object, player_range_x, player_range_y, player.range, player.range)

		end

		-- Update

		player.update = function(dt)

			-- Position

			player.directions[player.current_direction](dt)

			-- Sprite

			player.sprite = managers.animations[player.animation_status](player.current_animation, dt)

			-- Interaction range

			local player_range_x, player_range_y = get_player_range(player)
			world:update(player.range_object, player_range_x, player_range_y, player.range, player.range)
		end

		return player
	end
}
