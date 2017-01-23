local trees = {}

function trees.load(treeBottom, thingsTable)
	local sprites = data.plugins.sprites

	-- Load in the tree bottom

	treeBottom.sprite = sprites.getSprite('tree1Bottom')
	treeBottom.width = treeBottom.sprite.width
	treeBottom.height = treeBottom.sprite.height
	treeBottom.collides = true
	treeBottom.layer = 5

	table.insert(thingsTable, treeBottom)

	-- Generate a tree top

	local treeTopSprite = sprites.getSprite('tree1Top') 
	local treeTop = {
		sprite = treeTopSprite,
		width = treeTopSprite.width,
		height = treeTopSprite.height,
		lightBlockSprite = sprites.getSprite('tree1TopLightBlock'),
		collides = false,
		x = treeBottom.x - 60,
		y = treeBottom.y - 180,
		layer = 6
	}

	table.insert(thingsTable, treeTop)
end

function trees.save(thing, rawData)
	table.insert(rawData, {
		type = thing.type,
		x = thing.x,
		y = thing.y
	})
end

return trees
