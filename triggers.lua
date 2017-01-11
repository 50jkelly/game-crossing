local triggers = {}
local triggerX = {}
local triggerY = {}
local triggerWidth = {}
local triggerHeight = {}
local triggerOnFire = {}
local triggerOnStop = {}
local triggerIdle = {}
local triggerFiring = {}
local triggerFunctions = {}
local triggerEntity = {}
local count = 1

function triggers.assetsLoaded()
	triggerFunctions['item_pickup'] = function(triggerId)
		local inventory = data.plugins.inventory
		local items = data.plugins.items
		local actionBar = data.plugins.actionBar
		local staticEntities = data.plugins.staticEntities

		if inventory and items and staticEntities then
			local staticEntityId = triggerEntity[triggerId]
			local itemId = staticEntities.getEntity(staticEntityId).itemId
			local slot = inventory.findItem(itemId)
			if slot then
				inventory.slotQuantities[slot] = inventory.slotQuantities[slot] + 1
			else
				local newSlot = inventory.addItem(itemId, 1)
				if actionBar then
					local actionBarSlot = actionBar.getSlotIndex(newSlot)
					if not actionBarSlot then
						actionBarSlot = actionBar.nextEmptySlot()
					end
					if actionBarSlot then
						actionBar.setSlotValue(actionBarSlot, newSlot)
					end
				end
			end
			staticEntities.remove(staticEntityId)
			triggers.remove(triggerId)
		end
	end

	callHook('plugins', 'triggersLoaded')
end

function triggers.update()
	-- Fire triggers that are overlapping a dynamic entity
	for _, entity in ipairs(data.dynamicEntities) do
		for _, triggerId in ipairs(triggerIdle) do
			if overlapping(entity, triggers.getRect(triggerId)) then
				fire(triggerId)
			end
		end
	end

	-- Stop firing triggers that have no entities currently firing them
	local stopped = {}
	for index, triggerId in ipairs(triggerFiring) do
		for _, entity in ipairs(data.dynamicEntities) do
			if overlapping(entity, triggers.getRect(triggerId)) then
				stop(triggerId)
				break
			end
		end
	end
end

function triggers.saveGame()
	local saveLoad = data.plugins.saveLoad
	saveLoad.writeTable(triggerX, saveLoad.saveFilePath..'triggerX.txt')
	saveLoad.writeTable(triggerY, saveLoad.saveFilePath..'triggerY.txt')
	saveLoad.writeTable(triggerWidth, saveLoad.saveFilePath..'triggerWidth.txt')
	saveLoad.writeTable(triggerHeight, saveLoad.saveFilePath..'triggerHeight.txt')
	saveLoad.writeTable(triggerOnFire, saveLoad.saveFilePath..'triggerOnFire.txt')
	saveLoad.writeTable(triggerOnStop, saveLoad.saveFilePath..'triggerOnStop.txt')
	saveLoad.writeTable(triggerIdle, saveLoad.saveFilePath..'triggerIdle.txt')
	saveLoad.writeTable(triggerFiring, saveLoad.saveFilePath..'triggerFiring.txt')
	saveLoad.writeTable(triggerEntity, saveLoad.saveFilePath..'triggerEntity.txt')
end

function triggers.loadGame()
	local saveLoad = data.plugins.saveLoad
	triggerX = saveLoad.readTable(triggerX, saveLoad.saveFilePath..'triggerX.txt')
	triggerY = saveLoad.readTable(triggerY, saveLoad.saveFilePath..'triggerY.txt')
	triggerWidth = saveLoad.readTable(triggerWidth, saveLoad.saveFilePath..'triggerWidth.txt')
	triggerHeight = saveLoad.readTable(triggerHeight, saveLoad.saveFilePath..'triggerHeight.txt')
	triggerOnFire = saveLoad.readTable(triggerOnFire, saveLoad.saveFilePath..'triggerOnFire.txt')
	triggerOnStop = saveLoad.readTable(triggerOnStop, saveLoad.saveFilePath..'triggerOnStop.txt')
	triggerIdle = saveLoad.readArray(triggerIdle, saveLoad.saveFilePath..'triggerIdle.txt')
	triggerFiring = saveLoad.readArray(triggerFiring, saveLoad.saveFilePath..'triggerFiring.txt')
	triggerEntity = saveLoad.readTable(triggerEntity, saveLoad.saveFilePath..'triggerEntity.txt')
	count = table.getn(triggers.allTriggers()) + 1
end

function triggers.getRect(triggerId)
	return {
		x = triggerX[triggerId],
		y = triggerY[triggerId],
		width = triggerWidth[triggerId],
		height = triggerHeight[triggerId]
	}
end

function fire(triggerId)
	removeFromArray(triggerIdle, triggerId)
	table.insert(triggerFiring, triggerId)
	run(triggerOnFire, triggerId)
end

function stop(triggerId)
	removeFromArray(triggerFiring, triggerId)
	table.insert(triggerIdle, triggerId)
	run(triggerOnStop, triggerId)
end

function run(funcTable, triggerId)
	local funcId = funcTable[triggerId]
	if funcId then
		triggerFunctions[funcId](triggerId)
	end
end

function triggers.newTrigger(x, y, width, height, onFireId, onStopId, entityId)
	local id = 'trigger'..count
	count = count + 1
	triggerX[id] = x
	triggerY[id] = y
	triggerWidth[id] = width
	triggerHeight[id] = height
	if onFireId then triggerOnFire[id] = onFireId end
	if onStopId then triggerOnStop[id] = onStopId end
	if entityId then triggerEntity[id] = entityId end
	table.insert(triggerIdle, id)
end

function removeFromArray(array, triggerId)
	for index, value in ipairs(array) do
		if value == triggerId then
			table.remove(array, index)
			return
		end
	end
end

function triggers.remove(id)
	removeFromArray(triggerX, id)
	removeFromArray(triggerY, id)
	removeFromArray(triggerWidth, id)
	removeFromArray(triggerHeight, id)
	removeFromArray(triggerOnFire, id)
	removeFromArray(triggerOnStop, id)
	removeFromArray(triggerIdle, id)
	removeFromArray(triggerFiring, id)
end

function triggers.allTriggers()
	return concat(triggerIdle, triggerFiring)
end

return triggers
