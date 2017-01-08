local collision = {}

function collision.initialise()
	for _, item in ipairs(data.items) do
		item.collidingWith = {}
	end
end

function collision.update()
	-- Iterate over all items that can move and check if they are colliding with anything
	for _, item in ipairs(data.items) do
		if item.canMove then
			for _, otherItem in ipairs(data.items) do
				if item.id ~= otherItem.id then
					if overlapping(item, otherItem) then
						item.collision(otherItem)
					end
				end
			end
		end
	end
end

-- Private functions

function alreadyColliding(item1, item2)
	for _, item in ipairs(item1.collidingWith) do
		if item.id == item2.id then
			return true
		end
	end
	return false
end

return collision
