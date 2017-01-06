local viewport = {
	x = 0,
	y = 0,
	width = 0,
	height = 0
}

function viewport.load(data)
	viewport.x = 0
	viewport.y = 0
	viewport.width = data.screenWidth
	viewport.height = data.screenHeight
	return data
end

function viewport.update(data)
	local player = data.player
	viewport.x = player.x - (viewport.width / 2) + player.width + player.drawXOffset
	viewport.y = player.y - (viewport.height / 2) + player.height + player.drawYOffset
	return data
end

return viewport
