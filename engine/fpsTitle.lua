local fpsTitle = {}

function fpsTitle.update()
	love.window.setTitle("Crossing FPS: "..love.timer.getFPS())
end

return fpsTitle
