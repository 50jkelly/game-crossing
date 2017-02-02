local machine = require 'state_machines.enhanced'

return {
	new = function(controls, signal)
		return machine.create({
			initial = 'game',
			signal = signal,
			events = {
				{ name = 'pausegame', from = 'game', to = 'pause' },
				{ name = 'pausegame', from = 'pause', to = 'game' },
			},
		})
	end
}

