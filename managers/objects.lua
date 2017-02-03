local this = {}

local player_object = require 'objects.player'
local grass_object = require 'objects.plants.grass'
local flower_1_object = require 'objects.plants.flower_1'
local cursor_1_object = require 'objects.ui.cursor_1'

this.initialise = function(managers)
	this.objects = {
		player = function(x, y) return player_object.new(managers, x, y) end,
		plants = {
			grass = function(x, y) return grass_object.new(managers, x, y) end,
			flower_1 = function(world, x, y) return flower_1_object.new(managers, world, x, y) end,
		},
		ui = {
			cursor_1 = function(world) return cursor_1_object.new(managers, world) end,
		},
	}
end

return this
