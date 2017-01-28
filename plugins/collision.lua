local plugin = {}

-- Functions

function plugin.colliding(thing, otherThings)
	for i, otherThing in ipairs(otherThings) do
		local colliding = 
			thing.id ~= otherThing.id and
			thing.collides and otherThing.collides and
			overlapping(thing, otherThing)
		if colliding then
			return otherThing
		end
	end
end

return plugin
