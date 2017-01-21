local grass = {
	expand = {
		grass1 = function(thing, id, thingsTable)
			local sprites = data.plugins.sprites

			thing.sprite = sprites.getSprite('grass1')
			thing.width, thing.height = thing.sprite.sprite:getDimensions()
			thing.layer = 1

			thingsTable[id] = thing
		end
	},
	condense = {
		grass1 = function(thing, id, rawData)
			rawData[id] = {
				type = thing.type,
				subtype = thing.subtype,
				x = thing.x,
				y = thing.y
			}
		end
	}
}

return grass
