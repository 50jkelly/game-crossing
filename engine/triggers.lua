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

triggers.showName = private.newTrigger(
	function(thing, triggeredBy)
		print(thing.name)
	end,
	function(thing, triggeredBy)
		print('stopped')
	end)


return triggers
