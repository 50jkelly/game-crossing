local renderer = {}

function renderer.draw()
	table.sort(data.items, function(a, b)
		return a.y < b.y
	end)

	for _, item in ipairs(data.items) do
		if item.sprite then
			local drawX = item.x + item.drawXOffset
			local drawY = item.y + item.drawYOffset
			love.graphics.draw(item.sprite, drawX, drawY, 0, 1, 1, 0, 0)
		end

		if data.drawWorldPosition then
			love.graphics.setColor(255, 0, 0, 100)
			love.graphics.rectangle("fill", item.x, item.y, item.width, item.height)
			love.graphics.setColor(255,255,255,255)
		end
	end
end

return renderer
