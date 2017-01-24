local items = {}

items.jug = {
	name = 'Jug',
	sprite = 'jug',
	charges = 3,
	maxCharges = 3
}

items.seed = {
	name = 'Seed',
	sprite = 'itemSeed',
	placed = 'juvenileFlower'
}

items.juvenileFlower = {
	name = 'Juvenile Flower',
	sprite = 'flower1start',
	layer = 5,
	grow = 'flower',
	growTime = 4 * 60,
	growOffsetY = -15,
	interaction = true,
	water = 0
}

items.flower = {
	name = 'Flower',
	sprite = 'flower1',
	layer = 5,
	interaction = true,
	pickupItems = { 'seed', 'seed' }
}

return items
