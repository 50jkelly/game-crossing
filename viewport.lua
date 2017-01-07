local viewport = {
	x = 0,
	y = 0,
	width = 0,
	height = 0
}

function viewport.initialise()
	viewport.x = 0
	viewport.y = 0
	viewport.width = data.screenWidth
	viewport.height = data.screenHeight
end

function viewport.update()
	local player = data.player
	if player then
		viewport.x = player.x - (viewport.width / 2) + player.width + player.drawXOffset
		viewport.y = player.y - (viewport.height / 2) + player.height + player.drawYOffset
	end
end

function viewport.preDraw()
	love.graphics.push()
	love.graphics.translate(-viewport.x, -viewport.y)
end

function viewport.postDraw()
	love.graphics.pop()
end

return viewport
