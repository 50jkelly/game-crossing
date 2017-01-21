local dayNightCycle = {}

local sunrise = 'sunrise'
local day = 'day'
local sunset = 'sunset'
local night = 'night'

local times = {}
times[6 * 60] = sunrise
times[8 * 60] = day
times[20 * 60] = sunset
times[22 * 60] = night

local minutes = {}
minutes[sunrise] = 6 * 60
minutes[day] = 8 * 60
minutes[sunset] = 20 * 60
minutes[night] = 22 * 60

local nextTime = {}
nextTime[sunrise] = day
nextTime[day] = sunset
nextTime[sunset] = night
nextTime[night] = sunrise

local colors = {}
colors[sunrise] = {.3, .3, .7, 0}
colors[day] = {1., 1., 1., 0}
colors[sunset] = {1., 1., 1., 0}
colors[night] = {.3, .3, .7, 0}

-- Hooks

function dayNightCycle.initialise()
	dayNightCycle.timeOfDay = day
	dayNightCycle.ambientColor = {
		colors[day][1],
		colors[day][2],
		colors[day][3],
		colors[day][4]
	}
end

function dayNightCycle.update()
	local clock = data.plugins.clock
	if clock then
		local time = clock.getTime(true)
		local mins = time.hours * 60 + time.minutes

		dayNightCycle.timeOfDay = times[mins] or dayNightCycle.timeOfDay

		local nextTod = nextTime[dayNightCycle.timeOfDay]
		local nextMinutes = minutes[nextTod]
		local nextColor = colors[nextTod]
		local remaining = nextMinutes - mins

		for i=1, 3, 1 do
			local unit = (nextColor[i] - dayNightCycle.ambientColor[i]) / remaining
			dayNightCycle.ambientColor[i] = dayNightCycle.ambientColor[i] + unit
		end
	end
end

return dayNightCycle
