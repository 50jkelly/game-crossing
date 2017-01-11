local trees = {}
local treeCount = 0

-- Hooks

function trees.initialise()
	local staticEntities = data.plugins.staticEntities
	if staticEntities then
		staticEntities.add(newTree(20, 70, 'tree1'))
		staticEntities.add(newTree(20, 100, 'tree1'))
		staticEntities.add(newTree(50, 70, 'tree1'))
	end
end

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
