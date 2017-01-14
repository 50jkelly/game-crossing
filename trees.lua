local trees = {}
local treeCount = 0

-- Functions

function newTree(x, y, spriteId)
	treeCount = treeCount + 1
	return {
		id = "tree"..treeCount,
		collides = true,
		x = x,
		y = y,
		width = 30,
		height = 30,
		drawXOffset = -90,
		drawYOffset = -190,
		spriteId = spriteId
	}
end

return trees
