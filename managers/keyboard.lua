local this = {}

this.controls = {
	w = 'up',
	s = 'down',
	a = 'left',
	d = 'right',
	p = 'pause',
}

love.keypressed = function(key)
	this.keydown = this.controls[key]
	signal.emit('keypressed', this.controls[key])
end

love.keyreleased = function(key)
	if this.keydown == this.controls[key] then
		this.keydown = nil
		signal.emit('keyreleased', this.controls[key])
	end
end

return this
