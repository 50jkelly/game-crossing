local collision = {}

function collision.checkCollisions(mainItem, items)
	for _, item in ipairs(items) do
		local skip = mainItem.id == item.id
		if not skip and isColliding(mainItem, item) then return true end
	end
	return false
end

-- Private functions

function isColliding(item1, item2)
	return not (item1.x + item1.width < item2.x
		or item2.x + item2.width < item1.x
		or item1.y + item1.height < item2.y
		or item2.y + item2.height < item1.y)
end

return collision
