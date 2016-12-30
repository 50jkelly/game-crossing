local items = {}

function items.new(x, y, width, height)
	local item = {}
	item["x"] = x
	item["y"] = y
	item["width"] = width
	item["height"] = height
	item["parts"] = {}
	return item
end

function items.addPart(item, args)
	if args["x"] == nil then args["x"] = item["x"] end
	if args["y"] == nil then args["y"] = item["y"] end
	if args["width"] == nil then args["width"] = item["width"] end
	if args["height"] == nil then args["height"] = item["height"] end

	table.insert(item["parts"], args)
	return item
end

return items
