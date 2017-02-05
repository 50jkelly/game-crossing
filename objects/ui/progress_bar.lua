return {
	new = function(managers, x, y)
		local progress_bar = {}

		-- Basic

		progress_bar.x = x
		progress_bar.y = y
		progress_bar.width = 30
		progress_bar.height = 10

		-- Drawing

		progress_bar.animation = managers.animations.animations.progress_bar()
		progress_bar.hidden = true

		-- Initialisation

		progress_bar.initialise = function()

			-- Collectables

			signal.register('start_progress_bar', function(collectable)
				local percent = (collectable.action_timer - collectable.current_action_timer) / collectable.action_timer * 100
				local frame = math.floor(percent / (100 / 8)) + 1
				progress_bar.sprite = progress_bar.animation.frames[frame] or progress_bar.sprite
				progress_bar.x = collectable.x + collectable.width / 2 - progress_bar.width / 2
				progress_bar.y = collectable.y - progress_bar.height
				progress_bar.hidden = false
			end)

			signal.register('stop_progress_bar', function()
				progress_bar.hidden = true
			end)

		end

		-- Update

		progress_bar.update = function()
		end

		return progress_bar
	end
}
