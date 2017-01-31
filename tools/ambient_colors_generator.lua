local this = {}
local serpent = require 'libraries.serpent'

local calculate_transition_color = function(minutes, transition, duration, start_color, target_color)
	local result_color = {}
	for i, _ in ipairs(target_color) do
		local transition_progress = minutes - transition
		if transition_progress < 0 then return nil end
		if transition_progress > duration then return nil end
		result_color[i] = start_color[i] + (target_color[i] - start_color[i]) * (transition_progress / duration)
	end
	return result_color
end

local calculate_default_color = function(minutes, sunrise, sunset, day_color, night_color)
	if minutes > sunrise and minutes < sunset then return day_color end
	return night_color
end

this.run = function()
	local ambient_colors = {}
	for i=0, 24 * 60, 1 do
		sunrise = {time = 6 * 60, duration = 2 * 60}
		sunset = {time = 20 * 60, duration = 2 * 60}
		day_color, night_color = {1, 1, 1, 0}, {.3, .3, .7, 0}
		ambient_color = calculate_transition_color((i or 0), sunrise.time, sunrise.duration, night_color, day_color) or
			calculate_transition_color((i or 0), sunset.time, sunset.duration, day_color, night_color) or
			calculate_default_color((i or 0), sunrise.time, sunset.time, day_color, night_color)
		table.insert(ambient_colors, ambient_color)
	end
	local file = io.open('data/ambient_colors.lua', 'w')
	io.output(file)
	io.write(serpent.dump(ambient_colors))
	io.close(file)
end

return this
