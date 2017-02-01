local this = {}
local state_machine
local player
local signal

this.initialise = function(_player, _signal)
	player = _player
	signal = _signal
	state_machine = (require 'state_machines.movement').new(player, signal)
end

this.collision = function(object, layer_index, object_index)
	local same_object =
		layer_index == 2 and
		object_index == 1

	local collision =
		not same_object and
		object.collides and
		overlapping(player, object)

	if collision then
		signal.emit('collision')
	end
end

return this
