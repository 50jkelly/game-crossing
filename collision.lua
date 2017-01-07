local collision = {}

function collision.update()
	-- Iterate over all items that can move and check if they are colliding with anything
	for _, item in ipairs(data.items) do
		if item.canMove and checkCollisions(item, data.items) then
			collision.colliding = item
			callHook('plugins', 'collision')
		end
	end
end

-- Private functions

function checkCollisions(mainItem, items)
	for _, item in ipairs(items) do
		local skip = mainItem.id == item.id
		if not skip and isColliding(mainItem, item) then
			collision.collidingWith = item
			return true
		end
	end
	return false
end

function isColliding(item1, item2)
	return not (item1.x + item1.width < item2.x
		or item2.x + item2.width < item1.x
		or item1.y + item1.height < item2.y
		or item2.y + item2.height < item1.y)
end

return collision
