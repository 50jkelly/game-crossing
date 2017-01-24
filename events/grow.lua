local grow = {}

function grow.fire(thing, eventData)

	if not (thing.placed and thing.timeToGrow) then
		return
	end

	local clock = data.plugins.clock
	local things = data.plugins.things
	local minutes = clock.getMinutes()

	if minutes - thing.placed > thing.timeToGrow then
		things.removeThing(thing.id)
		things.addThing({
			x = thing.growsInto.x or thing.x,
			y = thing.growsInto.y or thing.y,
			type = thing.growsInto.type
		})
	end
end

return grow
