local layers = {}
local data = {}

function layers.addItem(layer, item)
	-- Add layers up to the requested layer if it doesn't already exist
	local tableSize = table.getn(data)
	if tableSize < layer then
		for i=tableSize, layer, 1 do
			table.insert(data, {})
		end
	end

	-- Add the item to the requested layer
	table.insert(data[layer], item)
end

function layers.draw(layer, viewport)
	love.graphics.push()
	love.graphics.translate(-viewport["x"], -viewport["y"])

	for key, item in pairs(data[layer]) do
		item.draw()
	end

	love.graphics.pop()
end

return layers
