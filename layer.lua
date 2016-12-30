local layers = {}
local data = {}

-- Public functions

function layers.addItem(item)
	local tableSize = table.getn(data)

	-- Iterate over the item parts
	for _, part in pairs(item["parts"]) do

		-- Add layers up to the requested layer if it doesn't already exist
		if tableSize < part["layer"] then
			for i=tableSize, part["layer"], 1 do
				table.insert(data, {})
			end
		end

		-- Add the part to the appropriate layer
		addToLayer(part)
	end
end

function layers.draw(layerIndex, viewport)
	love.graphics.push()
	love.graphics.translate(-viewport["x"], -viewport["y"])

	local layer = data[layerIndex]
	for _, part in pairs(layer) do
		love.graphics.draw(part["sprite"], part["x"], part["y"], 0, 1, 1, 0, 0)
	end

	love.graphics.pop()
end

-- Private functions

function addToLayer(part)
	local continueSearch = true
	local layer = data[part["layer"]]
	local numberOfParts = table.getn(layer)

	for i=numberOfParts, 1, 1 do
		local existingPart = layer[i]

		if existingPart == nil then
			table.insert(layer, part)
			continueSearch = false
		end

		if continueSearch == true and existingPart["y"] > part["y"] then
			table.insert(layer, i, part)
			continueSearch = false
		end
	end

	local notFound = continueSearch
	if notFound == true then
		table.insert(layer, part)
	end
end

return layers
