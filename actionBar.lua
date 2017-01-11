local actionBar = {}

-- Colors
actionBar.panelColor = {0, 0, 0, 100}
actionBar.borderColor = {50, 50, 50, 255}
actionBar.activatedPanelColor = {100, 100, 100, 100}
actionBar.activatedBorderColor = {50, 50, 50, 255}

-- Action bar slots
local numberOfSlots = 10
local activatedSlot = 1
local slots = {}

-- Action bar shortcuts
local shortcuts = {
	actionBar1 = '1',
	actionBar2 = '2',
	actionBar3 = '3',
	actionBar4 = '4',
	actionBar5 = '5',
	actionBar6 = '6',
	actionBar7 = '7',
	actionBar8 = '8',
	actionBar9 = '9',
	actionBar10 = '0'
}

-- Hooks
function actionBar.initialise()
	-- Initialise the slots so that they are empty
	for i=1, numberOfSlots, 1 do table.insert(slots, -1) end

	-- Hook up the controls
	local controls = data.plugins.controls
	if controls then
		for slot, key in pairs(shortcuts) do controls.add(slot, key) end
	end
end

function actionBar.keyPressed()
	if data.state == 'game' then
		local key = data.plugins.controls.currentKeyPressed
		if shortcuts[key] then
			activatedSlot = tonumber(string.match(key, 'actionBar(%d+)'))
		end
	end
end

function actionBar.saveGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath..'actionBarSlots.txt'
	saveLoad.writeTable(slots, file)
end

function actionBar.loadGame()
	local saveLoad = data.plugins.saveLoad
	local file = saveLoad.saveFilePath..'actionBarSlots.txt'
	slots = saveLoad.readArray(slots, file)
end

-- Functions

function actionBar.setSlotValue(actionBarSlot, value)
	slots[tonumber(actionBarSlot)] = value
end

function actionBar.getSlotValue(actionBarSlot)
	return slots[actionBarSlot]
end

function actionBar.getSlotIndex(value)
	for i, v in pairs(slots) do
		if v == value then
			return i
		end
	end
end

function actionBar.getSlotIndex(value)
	for i, v in ipairs(slots) do
		if v == value then
			return i
		end
	end
end

function actionBar.isShortcut(key)
	for shortcutKey, _ in pairs(shortcuts) do
		if shortcutKey == key then return true end
	end
	return false
end

function actionBar.getShortcutValue(index)
	return shortcuts[index]
end

function actionBar.getShortcutIndex(value)
	for i, v in shortcuts do
		if v == value then
			return i
		end
	end
end

function actionBar.numberOfSlots()
	return numberOfSlots
end

function actionBar.activatedSlot()
	return activatedSlot
end

function actionBar.clearValueFromSlots(value)
	local found = {}
	for i, v in ipairs(slots) do
		if v == value then
			table.insert(found, i)
		end
	end
	for _, v in pairs(found) do
		slots[v] = -1
	end
end

function actionBar.nextEmptySlot()
	for i, v in pairs(slots) do
		if v < 0 then
			return i
		end
	end
end

return actionBar
