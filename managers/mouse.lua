local this = {}
local managers

this.mouse_buttons = {
	'left',
	'right',
	'middle',
}

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
