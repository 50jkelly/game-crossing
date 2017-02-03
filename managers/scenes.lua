local this = {}

this.scenes = {
	village = require 'scenes.village.main',
}

this.initialise = function(managers)
	this.scenes.village.initialise(managers)
end

this.update = function(dt)
	this.scenes.village.update(dt)
end

this.draw = function()
	this.scenes.village.draw()
end

return this
