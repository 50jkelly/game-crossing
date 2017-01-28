local this = {} 
local game_seconds_per_real_second = 100
local seconds_in_minute = 60
local minutes_in_hour = 60
local hours_in_day = 24
local since_last_update = 0

local time = {
	days = 0,
	hours = 12,
	minutes = 0,
	seconds = 0,
}

this.initialise = function()
	this.load_game()
end

this.update = function(dt)

	-- State check

	if data.state ~= 'game' then
		return
	end

	-- Convert from real time

	local in_game_second = 1 / game_seconds_per_real_second

	-- Increment the second

	local clock_updated = false
	since_last_update = since_last_update + dt
	while since_last_update > in_game_second do
		time.seconds = time.seconds + 1
		since_last_update = since_last_update - in_game_second
		clock_updated = true
	end

	-- Increment the minute

	if time.seconds >= seconds_in_minute then
		time.minutes = time.minutes + 1
		time.seconds = 0
	end

	-- Increment the hour

	if time.minutes >= minutes_in_hour then
		time.hours = time.hours + 1
		time.minutes = 0
	end

	-- Increment the day

	if time.hours >= hours_in_day then
		time.days = time.days + 1
		time.hours = 0
	end

	-- Publish results

	if clock_updated then
		call_hook('plugins', 'clock_updated', {
			raw_time = time,
			string_time = string.format('%02d:%02d:%02d', time.hours, time.minutes, time.seconds),
			minutes_today = time.hours * minutes_in_hour + time.minutes,
			minutes_since_start = (time.days * hours_in_day + time.hours) * minutes_in_hour + time.minutes
		})
	end
end

this.save_game = function()
	data.plugins.persistence.write(time, 'saves/clock.lua')
end

this.load_game = function()
	time = data.plugins.persistence.read('saves/clock.lua')
end

return this
