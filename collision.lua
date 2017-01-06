local collision = {}

function collision.update(data)
	-- Iterate over all items that can move and check if they are colliding with anything
	for _, item in ipairs(data.items) do
		if item.canMove and checkCollisions(item, data.items) then
			collision.colliding = item
			callHook('plugins', 'collision')
		end
	end

	return data
end

-- Private functions

function checkCollisions(mainItem, items)
	for _, item in ipairs(items) do
		local skip = mainItem.id == item.id
		if not skip and isColliding(mainItem, item) then
			collision.directions = collisionDirection(mainItem, item)
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

function collisionDirection(item1, item2)
	local item1Edges = getEdges(item1)
	local item2Edges = getEdges(item2)
	local directions = {}

	directions.left = item1Edges.left < item2Edges.right and
		item1Edges.left > item2Edges.left and
		(item1Edges.top > item2Edges.top or
		item1Edges.bottom < item2Edges.bottom)

	directions.right = item1Edges.right > item2Edges.left and
		item1Edges.right < item2Edges.right and
		(item1Edges.top > item2Edges.top or
		item1Edges.bottom < item2Edges.bottom)

	directions.up = item1Edges.top < item2Edges.bottom and
		item1Edges.top > item2Edges.top and
		(item1Edges.left < item2Edges.right or
		item1Edges.right > item2Edges.left)

	directions.down = item1Edges.bottom > item2Edges.top and
		item1Edges.bottom < item2Edges.bottom and
		(item1Edges.left < item2Edges.right or
		item1Edges.right > item2Edges.left)

	return directions
end

function getEdges(item)
	return {
		top = item.y,
		bottom = item.y + item.height,
		left = item.x,
		right = item.x + item.width
	}
end

return collision
