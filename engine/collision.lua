local plugin = {}

-- Functions

function plugin.colliding(thing, otherThingsArray)
	for i, otherThing in pairs(otherThingsArray) do
		if thing.id ~= otherThing.id and overlapping(thing, otherThing) then
			return otherThing
		end
	end
end

return plugin
