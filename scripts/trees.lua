local trees = {
	expand = {
		tree1 = function(treeBottom, id, thingsTable)
			local sprites = data.plugins.sprites

			-- Load in the tree bottom

			treeBottom.sprite = sprites.getSprite('tree1Bottom')
			treeBottom.width = treeBottom.sprite.width
			treeBottom.height = treeBottom.sprite.height
			treeBottom.collides = true
			treeBottom.layer = 5

			thingsTable[id] = treeBottom

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

			local id = data.plugins.things.newId()
			thingsTable[id] = treeTop
		end
	},
	condense = {
		tree1 = function(thing, id, rawData)
			rawData[id] = {
				type = thing.type,
				subtype = thing.subtype,
				x = thing.x,
				y = thing.y
			}
		end
	}
}
return trees
