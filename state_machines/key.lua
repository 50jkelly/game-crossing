local machine = require 'state_machines.enhanced'

-- This state machine is for an individual keyboard key.
-- I want to know when a key:
-- 	Has been pressed down
-- 	Has been released
-- 	Has done a full press/release cycle

return {
	new = function(key, signal)
		return machine.create({
			initial = 'keyup',
			signal = signal,
			events = {
				{ name = 'keyboard_pressed',   from = 'keyup',    to = 'keydown' },
				{ name = 'keyboard_pressed',   from = 'keydown',  to = 'keydown' },
				{ name = 'keyboard_released',  from = 'keydown',  to = 'keyup' },
			},
			callbacks = {
				onbeforestatechange = function(self, event, from, to, args)
					return key == args.key
				end,
				onkeyboard_released = function(self, event, from, to)
					signal:emit('keyup', key)
					signal:emit('keypressed', key)
				end,
			},
		})
	end
}
