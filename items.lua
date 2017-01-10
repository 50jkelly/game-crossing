local items = {}

function items.initialise()
	data.items = {}
end

function items.loadGraphics()
	local seed = newItem('item_seed', 'Seed', 'images/item_seed.png')
	local book = newItem('item_book', 'Book', 'images/item_book.png')

	local inventory = data.plugins.inventory
	if inventory then
		inventory.addItem(seed)
		inventory.addItem(book)
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
