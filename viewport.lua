local viewport = {}

function viewport.load(x, y, width, height)
	viewport.x = x
	viewport.y = y
	viewport.width = width
	viewport.height = height
end

function viewport.update(player)
	viewport.x = player.worldX - (viewport.width / 2) + player.worldWidth + player.drawXOffset
	viewport.y = player.worldY - (viewport.height / 2) + player.worldHeight + player.drawYOffset
end

return viewport
