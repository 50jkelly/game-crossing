local plugin = {}

-- Functions

function plugin.colliding(thing, otherThings)
	for i, otherThing in pairs(otherThings) do
		if thing.id ~= otherThing.id and overlapping(thing, otherThing) then
			return otherThing
		end
	end
end

return plugin
