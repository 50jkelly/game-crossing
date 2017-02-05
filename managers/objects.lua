local this = {}

local player_object = require 'objects.player'
local grass_object = require 'objects.plants.grass'
local flower_1_object = require 'objects.plants.flower_1'
local cursor_1_object = require 'objects.ui.cursor_1'
local progress_bar_object = require 'objects.ui.progress_bar'
local inventory_object = require 'objects.ui.inventory'

this.initialise = function(managers)
	this.objects = {
		player = function(x, y) return player_object.new(managers, x, y) end,
		plants = {
			grass = function(x, y) return grass_object.new(managers, x, y) end,
			flower_1 = function(world, x, y) return flower_1_object.new(managers, world, x, y) end,
		},
		ui = {
			cursor_1 = function(world) return cursor_1_object.new(managers, world) end,
			progress_bar = function(x, y) return progress_bar_object.new(managers, x, y) end,
			inventory = function() return inventory_object.new(managers) end,
		},
	}
end

return this
