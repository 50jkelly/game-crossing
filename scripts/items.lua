local items = {}

function items.assetsLoaded()
	local sprites = data.plugins.sprites

	items.book = {
		name = 'Book',
		sprite = 'itemBook'
	}

	items.seed = {
		name = 'Seed',
		sprite = sprites.getSprite('itemSeed'),
		worldSprite = sprites.getSprite('flower1start'),
		placeable = true,
		placedType = 'flower',
		placedSubtype = 'flower1start'
	}
end

return items
