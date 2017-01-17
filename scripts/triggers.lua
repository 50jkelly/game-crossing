local triggers = {}
local private = {}

-- Private functions

function private.newTrigger(onFire, onStop)
	local firing = false
	return {
		onFire = function(thing, triggeredBy)
			if not firing then
				onFire(thing, triggeredBy)
				firing = true
			end
		end,
		onStop = function(thing, triggeredBy)
			firing = false
			onStop(thing, triggeredBy)
		end
	}
end

-- Public functions

triggers.canInteract = private.newTrigger(
	function(thing, triggeredBy)

		-- Indicate that this thing can be interacted with

		if not triggeredBy.canInteract then
			triggeredBy.canInteract = {}
		end

		table.insert(triggeredBy.canInteract, thing)

	end,
	function(thing, triggeredBy)

		-- Indicate that this thing can not currently be interacted with

		for i, canInteract in ipairs(triggeredBy.canInteract) do
			if thing.id == canInteract.id then
				table.remove(triggeredBy.canInteract, i)
				break
			end
		end
	end)


return triggers
