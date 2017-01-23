local clock = {} 
local gameSecondsInRealSecond = 5
local secondsInMinute = 60
local minutesInHour = 60
local hoursInDay = 24
local sinceLastUpdate = 0

local time = {
	days=0,
	hours=12,
	minutes=0,
	seconds=0
}

-- Hooks

function clock.initialise()
	clock.loadGame()
end

function clock.update(dt)

	-- Get the maximum length of one in game second in real life seconds

	local inGameSecond = 1 / 20000

	-- If more time has elapsed since the last update than one in-game second, we 
	-- increment our seconds counter

	sinceLastUpdate = sinceLastUpdate + dt
	while sinceLastUpdate > inGameSecond do
		time.seconds = time.seconds + 1
		sinceLastUpdate = sinceLastUpdate - inGameSecond
	end

	-- Increment the minute if we have too many seconds

	if time.seconds >= secondsInMinute then
		time.minutes = time.minutes + 1
		time.seconds = 0
	end

	-- Increment the hour if we have too many minutes

	if time.minutes >= minutesInHour then
		time.hours = time.hours + 1
		time.minutes = 0
	end

	-- Increment the day if we have too many hours

	if time.hours >= hoursInDay then
		time.days = time.days + 1
		time.hours = 0
	end
end

function clock.saveGame()
	data.plugins.persistence.write(time, 'saves/clock.lua')
end

function clock.loadGame()
	time = data.plugins.persistence.read('saves/clock.lua')
end

-- Functions

function clock.getTime(raw)
	if raw then
		return time
	else
		return string.format("%02d:%02d:%02d", time.hours, time.minutes, time.seconds)
	end
end

function clock.getMinutes(timeFrame)
	if timeFrame == 'day'then
		return time.hours * 60 + time.minutes
	end

	local hours = time.days * 24 + time.hours
	return hours * 60 + time.minutes
end

return clock
