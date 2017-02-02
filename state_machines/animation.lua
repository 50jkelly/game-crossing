local machine = require 'state_machines.enhanced'

return {
	new = function(object, signal)
		return machine.create({
			initial = 'down_1',
			signal = signal,
			events = {
				{ name = 'firstupframe',     from = '*',        to = 'up_1' },
				{ name = 'nextupframe',      from = '*',        to = 'up_1' },
				{ name = 'nextupframe',      from = 'up_1',     to = 'up_2' },
				{ name = 'nextupframe',      from = 'up_2',     to = 'up_3' },
				{ name = 'nextupframe',      from = 'up_3',     to = 'up_4' },
				{ name = 'nextupframe',      from = 'up_4',     to = 'up_5' },
				{ name = 'nextupframe',      from = 'up_5',     to = 'up_6' },
				{ name = 'nextupframe',      from = 'up_6',     to = 'up_7' },
				{ name = 'nextupframe',      from = 'up_7',     to = 'up_8' },
				{ name = 'nextupframe',      from = 'up_8',     to = 'up_1' },

				{ name = 'firstdownframe',   from = '*',        to = 'down_1' },
				{ name = 'nextdownframe',    from = '*',        to = 'down_1' },
				{ name = 'nextdownframe',    from = 'down_1',   to = 'down_2' },
				{ name = 'nextdownframe',    from = 'down_2',   to = 'down_3' },
				{ name = 'nextdownframe',    from = 'down_3',   to = 'down_4' },
				{ name = 'nextdownframe',    from = 'down_4',   to = 'down_5' },
				{ name = 'nextdownframe',    from = 'down_5',   to = 'down_6' },
				{ name = 'nextdownframe',    from = 'down_6',   to = 'down_7' },
				{ name = 'nextdownframe',    from = 'down_7',   to = 'down_8' },
				{ name = 'nextdownframe',    from = 'down_8',   to = 'down_1' },

				{ name = 'firstleftframe',   from = '*',        to = 'left_1' },
				{ name = 'nextleftframe',    from = '*',        to = 'left_1' },
				{ name = 'nextleftframe',    from = 'left_1',   to = 'left_2' },
				{ name = 'nextleftframe',    from = 'left_2',   to = 'left_3' },
				{ name = 'nextleftframe',    from = 'left_3',   to = 'left_4' },
				{ name = 'nextleftframe',    from = 'left_4',   to = 'left_5' },
				{ name = 'nextleftframe',    from = 'left_5',   to = 'left_6' },
				{ name = 'nextleftframe',    from = 'left_6',   to = 'left_7' },
				{ name = 'nextleftframe',    from = 'left_7',   to = 'left_8' },
				{ name = 'nextleftframe',    from = 'left_8',   to = 'left_1' },

				{ name = 'firstrightframe',  from = '*',        to = 'right_1' },
				{ name = 'nextrightframe',   from = '*',        to = 'right_1' },
				{ name = 'nextrightframe',   from = 'right_1',  to = 'right_2' },
				{ name = 'nextrightframe',   from = 'right_2',  to = 'right_3' },
				{ name = 'nextrightframe',   from = 'right_3',  to = 'right_4' },
				{ name = 'nextrightframe',   from = 'right_4',  to = 'right_5' },
				{ name = 'nextrightframe',   from = 'right_5',  to = 'right_6' },
				{ name = 'nextrightframe',   from = 'right_6',  to = 'right_7' },
				{ name = 'nextrightframe',   from = 'right_7',  to = 'right_8' },
				{ name = 'nextrightframe',   from = 'right_8',  to = 'right_1' },
			},
			callbacks = {
				onbeforestatechange = function(self, event, from, to, args)
					object.time_since_last_frame = (object.time_since_last_frame or 0) + dt
					return
						event == 'firstupframe' or
						event == 'firstdownframe' or
						event == 'firstleftframe' or
						event == 'firstrightframe' or
						object.time_since_last_frame > 1 / object.fps
				end,
				onstatechange = function(self, event, from, to)
					object.time_since_last_frame = 0
					object.sprite = graphics['sprites_'..object.name..'_'..to]
				end,
			},
		})
	end
}
