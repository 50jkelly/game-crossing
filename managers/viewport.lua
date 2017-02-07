local this = {}

this.initialise = function()
	this.x = 0
	this.y = 0
end

this.update = function(scene, object)
	local object_center_x = object.x + object.width / 2
	local object_center_y = object.y + object.height / 2
	this.width = love.graphics.getWidth()
	this.height = love.graphics.getHeight()
	this.x = object_center_x - this.width / 2
	this.y = object_center_y - this.height / 2
	if this.x < 0 then this.x = 0 end
	if this.y < 0 then this.y = 0 end
	if this.x > scene.width - this.width then
		this.x = scene.width - this.width
	end
	if this.y > scene.height - this.height then
		this.y = scene.height - this.height
	end
end

return this
