local this = {}

local stack_item = require 'items.stack'

-- Initialisation

this.initialise = function()
	this.items = {
		stack = function(amount, sprite) return stack_item.new(amount, sprite) end,
	}
end

return this
