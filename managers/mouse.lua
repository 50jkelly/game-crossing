local this = {}
local managers

this.mouse_buttons = {
	'left',
	'right',
	'middle',
}

this.initialise = function(_managers)
	managers = _managers
	love.mouse.setVisible(false)
	this.cursor = managers.objects.objects.ui.cursor_1()
end

this.draw = function()
	love.graphics.draw(this.cursor.sprite, love.mouse.getX(), love.mouse.getY())
end

love.mousepressed = function(x, y, button)
	this.mousedown = this.mouse_buttons[button]
	signal.emit('mousepressed', this.mouse_buttons[button], x, y)
end

love.mousereleased = function(x, y, button)
	if this.mousedown == this.mouse_buttons[button] then
		this.mousedown = nil
		signal.emit('mousereleased', this.mouse_buttons[button], x, y)
	end
end

return this
