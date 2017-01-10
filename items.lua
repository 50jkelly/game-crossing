local items = {}

function items.initialise()
	items.itemLookup = {}
end

function items.loadGraphics()
	items.itemLookup['item_seed'] = newItem('item_seed', 'Seed', 'images/item_seed.png')
	items.itemLookup['item_book'] = newItem('item_book', 'Book', 'images/item_book.png')

	local inventory = data.plugins.inventory
	if inventory then
		inventory.addItem(items.itemLookup['item_seed'], 110)
		inventory.addItem(items.itemLookup['item_book'], 3)
		inventory.highlightedSlot = 1
	end
end

function newItem(id, name, spritePath)
	local sprite = love.graphics.newImage(spritePath)
	return {
		id = id,
		name = name,
		sprite = sprite
	}
end

return items
