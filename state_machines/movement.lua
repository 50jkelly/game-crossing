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
				object.state = self.current
				object.animating = true
				object.y = object.y - object.speed * args.dt
			end,
			ondown = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.state = self.current
				object.animating = true
				object.y = object.y + object.speed * args.dt
			end,
			onleft = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.state = self.current
				object.animating = true
				object.x = object.x - object.speed * args.dt
			end,
			onright = function(self, event, from, to, args)
				object.oldx, object.oldy = object.x, object.y
				object.state = self.current
				object.animating = true
				object.x = object.x + object.speed * args.dt
			end,
			onstop = function(self, event, from, to, args)
				object.frame = 1
				object.animating = false
			end,
			oncollision = function(self, event, from, to, args)
				object.frame = 1
				object.animating = false
				object.x, object.y = object.oldx, object.oldy
			end,
		}})
	end

	return this
