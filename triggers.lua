local triggers = {}

-- A trigger is an area of the ground that runs a script or calls a hook when triggered
-- When it calls a hook, it should add the entity that caused the trigger to fire

function triggers.initialise()
	triggers.count = 1
	data.triggers = {}

	newTrigger(200, 200, 50, 50, function(trigger)
		triggers.messageBoxes = {}
		
		local text = 'The player is not holding anything.'
		local inventory = data.plugins.inventory
		if inventory then
			local quickSlot = inventory.quickSlots[inventory.activatedSlot]
			local item, quantity = inventory.getItem(quickSlot)
			if item then
				text = 'The player is holding ' ..quantity .. ' ' ..item.name.. 's.'
			end
		end

		table.insert(triggers.messageBoxes, {
			x = 10,
			y = 10,
			width = 200,
			height = 50,
			text = text
		})
	end,
	function(trigger)
		triggers.messageBoxes = {}
	end)
end

function triggers.update()
	for _, entity in ipairs(data.dynamicEntities) do
		for _, trigger in ipairs(data.triggers) do
			if overlapping(entity, trigger) and trigger.firing == false then
				trigger.firing = true
				trigger.entity = entity
				trigger.onFire(trigger)
			end
		end
	end

	-- Reset triggers that are not currently being triggered
	for _, trigger in ipairs(data.triggers) do
		if trigger.firing then
			local anyOverlapping = false
			for _, entity in ipairs(data.dynamicEntities) do
				anyOverlapping = anyOverlapping or overlapping(entity, trigger)
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
