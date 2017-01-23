local juvenile_flowers = {}

function juvenile_flowers.save(thing, rawData)
	table.insert(rawData, {
		type = thing.type,
		x = thing.x,
		y = thing.y,
		planted = thing.planted
	})
end

function juvenile_flowers.load(thing, thingsTable)
	local sprites = data.plugins.sprites
	local clock = data.plugins.clock

	thing.sprite = sprites.getSprite('flower1start')
	thing.width = thing.sprite.width
	thing.height = thing.sprite.height
	thing.layer = 2
	thing.events = { 'grow' }
	thing.growsInto = {
		y = thing.y - 15,
		type = 'flower',
	}
	thing.timeToGrow = 60 * 24

	table.insert(thingsTable, thing)
end

return juvenile_flowers
