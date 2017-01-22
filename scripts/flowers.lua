local flowers = {
	expand = {
		flower1 = function(thing, id, thingsTable)
			local sprites = data.plugins.sprites

			thing.sprite = sprites.getSprite('flower1')
			thing.lightSprite = sprites.getSprite('flower1Light')
			thing.lightX = 10
			thing.lightY = 8
			thing.width = thing.sprite.width
			thing.height = thing.sprite.height
			thing.layer = 2

			thingsTable[id] = thing
		end
	},
	condense = {
		flower1 = function(thing, id, rawData)
			rawData[id] = {
				type = thing.type,
				subtype = thing.subtype,
				x = thing.x,
				y = thing.y
			}
		end
	}
}
return flowers
