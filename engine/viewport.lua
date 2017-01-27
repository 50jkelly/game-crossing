local this = {}

function this.initialise()
	this.x = 0
	this.y = 0
	this.width = love.graphics.getWidth()
	this.height = love.graphics.getHeight()
end

function this.update()
	local player = data.plugins.player
	if player then
		this.x = player.get_center().x
		this.y = player.get_center().y
	end
end

function this.pre_draw()
	love.graphics.push()
	love.graphics.translate(-this.x, -this.y)
end

function this.post_draw()
	love.graphics.pop()
end

return this
