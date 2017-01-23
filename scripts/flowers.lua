local flowers = {}

function flowers.load(thing, thingsTable)
	local sprites = data.plugins.sprites

	thing.sprite = sprites.getSprite('flower1')
	thing.lightSprite = sprites.getSprite('flower1Light')
	thing.lightY = 8
	thing.width = thing.sprite.width
	thing.height = thing.sprite.height
	thing.layer = 2
	thing.events = { 'pickup' }
	thing.pickupItems = { 'seed', 'seed' }

	table.insert(thingsTable, thing)
end


function flowers.save(thing, rawData)
	table.insert(rawData, {
		type = thing.type,
		x = thing.x,
		y = thing.y
	})
end

return flowers
