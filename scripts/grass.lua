local grass = {}

function grass.load(thing, thingsTable)
	local sprites = data.plugins.sprites

	thing.sprite = sprites.getSprite('grass1')
	thing.width, thing.height = thing.sprite.sprite:getDimensions()
	thing.layer = 1

	table.insert(thingsTable, thing)
end

function grass.save(thing, rawData)
	table.insert(rawData, {
		type = thing.type,
		subtype = thing.subtype,
		x = thing.x,
		y = thing.y
	})
end

return grass
