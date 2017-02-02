local machine = require 'state_machines.enhanced'

return {
	new = function(key, controls, signal)
		return machine.create({
			initial = 'idle',
			signal = signal,
			events = {
				{ name = 'keypressed',          from = 'idle',      to = 'adding' },
				{ name = 'keypressresolved',    from = 'adding',    to = 'idle' },
				{ name = 'keyreleased',         from = 'idle',      to = 'removing' },
				{ name = 'keyreleaseresolved',  from = 'removing',  to = 'idle' },
				{ name = 'checkkey',            from = 'idle',      to = 'checking' },
				{ name = 'keychecked',          from = 'checking',  to = 'idle' },
			},
			callbacks = {
				onkeypressed = function(self, event, from, to, args)
					key = args.key
					signal.emit('keypressresolved')
				end,
				onkeyreleased = function(self, event, from, to, args)
					if key == args.key then
						key = nil
						signal.emit('stop')
					end
					signal.emit('keyreleaseresolved')
				end,
				onchecking = function(self, event, from, to, args)
					if controls[key] then
						signal.emit(controls[key])
					end
					signal.emit('keychecked')
				end,
			}
		})
	end
}
