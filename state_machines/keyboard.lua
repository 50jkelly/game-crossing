local machine = require 'state_machines.enhanced'

return {
	new = function(keys, signal)
		return machine.create({
			initial = 'idle',
			signal = signal,
			events = {
				{ name = 'keypressed',   from = 'idle',      to = 'adding' },
				{ name = 'keyadded',     from = 'adding',    to = 'idle' },
				{ name = 'keyreleased',  from = 'idle',      to = 'removing' },
				{ name = 'keyremoved',   from = 'removing',  to = 'idle' },
				{ name = 'checkkeys',    from = 'idle',      to = 'checking' },
				{ name = 'keyschecked',  from = 'checking',  to = 'idle' },
			},
			callbacks = {
				onadding = function(self, event, from, to, args)
					table.insert(keys, args.key)
					signal.emit('keyadded')
				end,
				onremoving = function(self, event, from, to, args)
					for i, key in pairs(keys) do
						if key == args.key then
							table.remove(keys, i)
							break
						end
					end
					signal.emit('keyremoved')
				end,
				onchecking = function(self, event, from, to, args)
					for _, key in pairs(keys) do
						if args.controls[key] then
							signal.emit(args.controls[key], args)
						end
					end
					signal.emit('keyschecked')
				end
			}
		})
	end
}
