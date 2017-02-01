local machine = require 'libraries.statemachine'

return {
	create = function(args)
		local this = machine.create(args)

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
