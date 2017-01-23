local grow = {}

function grow.fire(thing, eventData)
	local clock = data.plugins.clock
	local things = data.plugins.things

	local time = clock.getTime(true)
	local hours = time.days * 24 + time.hours
	local minutes = hours * 60 + time.minutes

	if minutes - thing.planted > thing.timeToGrow then
		things.removeThing(thing.id)
		things.addThing({
			x = thing.growsInto.x or thing.x,
			y = thing.growsInto.y or thing.y,
			type = thing.growsInto.type,
			subtype = thing.growsInto.subtype
		})
	end
end

return grow
