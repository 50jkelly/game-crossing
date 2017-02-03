local this = {}

local player_object = require 'objects.player'
local grass_object = require 'objects.plants.grass'
local flower_1_object = require 'objects.plants.flower_1'

this.initialise = function(managers)
	this.objects = {
		player = function(x, y) return player_object.new(managers, x, y) end,
		plants = {
			grass = function(x, y) return grass_object.new(managers, x, y) end,
			flower_1 = function(x, y) return flower_1_object.new(managers, x, y) end,
		},
	}
end

return this
