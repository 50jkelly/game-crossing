local items = {}
local itemNames = {}
local itemSprites = {}
local itemCount = 0

local scale = 0.5
items.width = 50 * scale
items.height = 50 * scale

function items.initialise()
	addItem('item_book', 'Book', 'item_book')
	addItem('item_seed', 'Seed', 'item_seed')
	items.addToWorld('item_seed', 100, 200)
	items.addToWorld('item_seed', 100, 230)
	items.addToWorld('item_seed', 100, 260)
end

function addItem(id, name, spriteId)
	itemNames[id] = name
	itemSprites[id] = spriteId
end

function items.addToWorld(itemId, x, y)
	if itemId == -1 then return end
	itemCount = itemCount + 1
	local id = 'item' .. itemCount
	local spriteId = itemSprites[itemId]

	local staticEntities = data.plugins.staticEntities
	if staticEntities then
		staticEntities.add({
			id = id,
			itemId = itemId,
			collides = false,
			x = x,
			y = y,
			width = items.width,
			height = items.height,
			drawXOffset = 0,
			drawYOffset = 0,
			scale = scale,
			spriteId = spriteId
		})

		local triggers = data.plugins.triggers
		if triggers then
			triggers.newTrigger(x, y, items.width, items.height, 'item_pickup', nil, id)
		end
	end
end

function items.getName(id)
	return itemNames[id]
end

return items
