local dayNightCycle = {}

function dayNightCycle.update()
	local clock = data.plugins.clock
	if clock then

		-- The ambient light level should be a function of the total minutes elapsed
		-- in the current day

		local minutes = clock.getMinutes('day')

		-- The function involves the degree to which the current minutes exceeds
		-- particular thresholds throughout the day

		local sunrise = 6 * 60
		local sunset = 20 * 60

		-- The function also involves the duration of transition from one color to
		-- another once the thresholds have been exceeded

		local sunrise_duration = 2 * 60
		local sunset_duration = 2 * 60

		-- Of course, the function is primarily concerned with the color of the
		-- ambient lighting during the day and the night

		local day_color = {1, 1, 1, 0}
		local night_color = {.3, .3, .7, 0}

		dayNightCycle.ambientColor = 
			calculate_transition(minutes, sunrise, sunrise_duration, night_color, day_color) or
			calculate_transition(minutes, sunset, sunset_duration, day_color, night_color) or
			dayNightCycle.ambientColor or
			calculate_default_color(minutes, sunrise, sunset, day_color, night_color)
	end
end

function calculate_transition(minutes, transition, duration, start_color, target_color)
	local result_color = {}

	for i, _ in ipairs(target_color) do
		local transition_progress = minutes - transition

		if transition_progress <= 0 then
			return nil
		end

		if transition_progress > duration then
			return nil
		end

		local color_difference = target_color[i] - start_color[i]
		transition_progress = transition_progress / duration
		result_color[i] = start_color[i] + color_difference * transition_progress
	end

	return result_color
end

function calculate_default_color(minutes, sunrise, sunset, day_color, night_color)
	if minutes > sunrise and minutes < sunset then
		return day_color
	else
		return night_color
	end
end

return dayNightCycle
