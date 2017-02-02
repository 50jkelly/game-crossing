local this = {}
local machine = require 'state_machines.enhanced'

this.new = function(object, signal)
	return machine.create({
		initial = 'idle',
		signal = signal,
		events = {
			{ name = 'moveup',     from = { 'up',  'down',  'left',  'right',  'idle',  'blocked_down',  'blocked_left',  'blocked_right' },  to = 'up' },
			{ name = 'movedown',   from = { 'up',  'down',  'left',  'right',  'idle',  'blocked_up',    'blocked_left',  'blocked_right' },  to = 'down' },
			{ name = 'moveleft',   from = { 'up',  'down',  'left',  'right',  'idle',  'blocked_up',    'blocked_down',  'blocked_right' },  to = 'left' },
			{ name = 'moveright',  from = { 'up',  'down',  'left',  'right',  'idle',  'blocked_up',    'blocked_down',  'blocked_left' },   to = 'right' },
			{ name = 'stop',       from = { 'up', 'down', 'left', 'right' }, to = 'idle' },
			{ name = 'collision',  from = 'up',     to = 'blocked_up' },
			{ name = 'collision',  from = 'down',   to = 'blocked_down' },
			{ name = 'collision',  from = 'left',   to = 'blocked_left' },
			{ name = 'collision',  from = 'right',  to = 'blocked_right' },
		},
		callbacks = {
			onup = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.y = object.y - object.speed * dt
				signal.emit('nextupframe', args)
			end,
			ondown = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.y = object.y + object.speed * dt
				signal.emit('nextdownframe', args)
			end,
			onleft = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.x = object.x - object.speed * dt
				signal.emit('nextleftframe', args)
			end,
			onright = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.x = object.x + object.speed * dt
				signal.emit('nextrightframe', args)
			end,
			onstop = function(self, event, from, to, args)
				if from == 'up' then signal.emit('firstupframe', args) end
				if from == 'down' then signal.emit('firstdownframe', args) end
				if from == 'left' then signal.emit('firstleftframe', args) end
				if from == 'right' then signal.emit('firstrightframe', args) end
			end,
			oncollision = function(self, event, from, to, args)
				object.x, object.y = object.oldx, object.oldy
				if from == 'up' then signal.emit('firstupframe', args) end
				if from == 'down' then signal.emit('firstdownframe', args) end
				if from == 'left' then signal.emit('firstleftframe', args) end
				if from == 'right' then signal.emit('firstrightframe', args) end
			end,
			onleaveblocked_up = function(self, event, from, to)
				signal.emit('resetcollision')
			end,
			onleaveblocked_down = function(self, event, from, to)
				signal.emit('resetcollision')
			end,
			onleaveblocked_left = function(self, event, from, to)
				signal.emit('resetcollision')
			end,
			onleaveblocked_right = function(self, event, from, to)
				signal.emit('resetcollision')
			end,
		}})
	end

	return this
