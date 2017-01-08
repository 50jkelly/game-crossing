local triggers = {}

-- A trigger is an area of the ground that runs a script or calls a hook when triggered
-- When it calls a hook, it should add the entity that caused the trigger to fire

function triggers.initialise()
	triggers.count = 1
	data.triggers = {}

	newTrigger(200, 200, 50, 50, function(trigger)
		triggers.messageBoxes = {}
		table.insert(triggers.messageBoxes, {
			x = 10,
			y = 10,
			width = 200,
			height = 50,
			text = "Trigger fired"
		})
	end,
	function(trigger)
		triggers.messageBoxes = {}
	end)
end

function triggers.update()
	for _, item in ipairs(data.items) do
		if item.canMove then
		for _, trigger in ipairs(data.triggers) do
				if overlapping(item, trigger) and trigger.firing == false then
					trigger.firing = true
					trigger.item = item
					trigger.onFire(trigger)
				end
			end
		end
	end

	-- Reset triggers that are not currently being triggered
	for _, trigger in ipairs(data.triggers) do
		if trigger.firing then
			local anyOverlapping = false
			for _, item in ipairs(data.items) do
				if item.canMove then
					anyOverlapping = anyOverlapping or overlapping(item, trigger)
				end
			end
			if anyOverlapping == false then
				trigger.firing = false
				trigger.onStop(trigger)
				trigger.item = nil
			end
		end
	end
end

-- Private functions

function newTrigger(x, y, width, height, onFire, onStop)
	table.insert(data.triggers, {
		id = 'trigger'..triggers.count,
		x = x,
		y = y,
		width = width,
		height = height,
		onFire = onFire,
		onStop = onStop,
		firing = false
	})
	triggers.count = triggers.count + 1
end

return triggers
