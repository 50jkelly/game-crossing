local this = {}

this.time = {
	seconds = 0,
	minutes = 0,
	hours = 0,
	days = 0,
	months = 0,
	years = 0,
}

local seconds_in_minute = 60
local minutes_in_hour = 60
local hours_in_day = 24
local days_in_month = 7
local months_in_year = 12
local in_game_seconds_per_second = 1
local time_since_last_second = 0

this.update = function(dt)
	time_since_last_second = time_since_last_second + dt
	while time_since_last_second > 1 / in_game_seconds_per_second do
		this.time.seconds = this.time.seconds + 1
		time_since_last_second = time_since_last_second - 1 / in_game_seconds_per_second
	end

	while this.time.seconds >= seconds_in_minute do
		this.time.minutes = this.time.minutes + 1
		this.time.seconds = this.time.seconds - seconds_in_minute
	end

	while this.time.minutes >= minutes_in_hour do
		this.time.hours = this.time.hours + 1
		this.time.minutes = this.time.minutes - minutes_in_second
	end

	while this.time.hours >= hours_in_day do
		this.time.days = this.time.days + 1
		this.time.hours = this.time.hours - hours_in_day
	end

	while this.time.days >= days_in_month do
		this.time.months = this.time.months + 1
		this.time.days = this.time.days - days_in_month
	end

	while this.time.months >= months_in_year do
		this.time.years = this.time.years + 1
		this.time.months = this.time.months - months_in_year
	end
end

this.to_minutes = function(time)
	time = time or this.time
	local minutes_in_years = this.time.years * months_in_year * days_in_month * hours_in_day * minutes_in_hour
	local minutes_in_months = this.time.months * days_in_month * hours_in_day * minutes_in_hour
	local minutes_in_days = this.time.days * hours_in_day * minutes_in_hour
	local minutes_in_hours = this.time.hours * minutes_in_hour
	return minutes_in_hours + minutes_in_months + minutes_in_days + minutes_in_hours + time.minutes
end

this.to_seconds = function(time)
	time = time or this.time
	return this.to_minutes(time) * seconds_in_minute + time.seconds
end

return this
