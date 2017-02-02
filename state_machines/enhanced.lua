local machine = require 'libraries.statemachine'

return {
	create = function(args)
		-- Allow an onbeforestatechange calback to be used
		for name, callback in pairs(args.callbacks or {}) do
			if name == 'onbeforestatechange' then
				local added = {}
				for _, event in ipairs(args.events) do
					if not added[event.name] then
						args.callbacks['onbefore'..event.name] = callback
						added[event.name] = true
					end
				end
			end
		end

		local this = machine.create(args)

		-- Allow state transitions to be triggered using signal events
		if args.signal then
			local registered = {}
			for _, event in ipairs(args.events or {}) do
				if not registered[event.name] then
					args.signal.register(event.name, function(args)
						this[event.name](this, args)
					end)
					registered[event.name] = true
				end
			end
		end

		return this
	end
}
