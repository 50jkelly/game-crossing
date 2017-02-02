local machine = require 'state_machines.enhanced'

return {
	new = function(object, signal)
		return machine.create({
			initial = 'nocollision',
			signal = signal,
			events = {
				{ name = 'checkcollision', from = 'nocollision', to = 'collision' },
				{ name = 'resetcollision', from = 'collision', to = 'nocollision' },
			},
			callbacks = {
				onbeforecheckcollision = function(self, event, from, to, args)
					for object_index, other_object in ipairs(colliders[current_scene] or {}) do
						local same_object = object_index == args.object_index

						local collision =
							not same_object and
							object.collides and
							other_object.collides and
							overlapping(object, other_object)

						if collision then
							return true
						end
					end
					return false
				end,
				oncollision = function(self, event, from, to, args)
					signal.emit('collision', args)
				end
			},
		})
	end
}
