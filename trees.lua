local trees = {}
local treeCount = 0

function trees.initialise()
	local tree1Sprite = love.graphics.newImage("images/tree1.png")

	table.insert(data.staticEntities, newTree(0, 0, tree1Sprite))
	table.insert(data.staticEntities, newTree(0, 30, tree1Sprite))
	table.insert(data.staticEntities, newTree(30, 0, tree1Sprite))
end

function newTree(x, y, sprite)
	treeCount = treeCount + 1
	return {
		id = "tree"..treeCount,
		x = x,
		y = y,
		width = 30,
		height = 30,
		drawXOffset = -90,
		drawYOffset = -190,
		sprite = sprite
	}
end

return trees
