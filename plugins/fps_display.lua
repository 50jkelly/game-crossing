local this = {}

function this.update()
	love.window.setTitle("Crossing FPS: "..love.timer.getFPS())
end

return this
