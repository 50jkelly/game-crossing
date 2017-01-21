local viewport = {}

-- Hooks

function viewport.initialise()
	viewport.x = 0
	viewport.y = 0
	viewport.width = 800
	viewport.height = 600
end

function viewport.update()
	local player = data.plugins.player
	if player then
		local playerRect = player.getRect()

		viewport.x = playerRect.x +
			playerRect.width -
			(viewport.width / 2)

		viewport.y = playerRect.y +
			playerRect.height -
			(viewport.height / 2)
	end
end

function viewport.preDraw()
	love.graphics.push()
	love.graphics.translate(-viewport.x, -viewport.y)
end

function viewport.postDraw()
	love.graphics.pop()
end

function love.resize(width, height)
	viewport.width = width
	viewport.height = height
end

return viewport
