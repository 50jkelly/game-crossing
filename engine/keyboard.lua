local keyboard = {}

keyboard.keys = {
	up = "w",
	down = "s",
	left= "a",
	right = "d",
	use = 'e',
	drop = 'r',
	openInventory = 'i',
	saveGame = 'z',
	loadGame = 'l',
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

function keyboard.update()
	for key, _ in pairs(keyboard.keys) do
		if love.keyboard.isDown(keyboard.keys[key]) then
			keyboard.currentKeyDown = key
			callHook('plugins', 'keyDown')
		end
	end
end

function love.keypressed(key)
	local action = nil

	for k, _ in pairs(keyboard.keys) do
		if keyboard.keys[k] == key then
			action = k
		end
	end

	if action then
		keyboard.currentKeyPressed = action
		callHook('plugins', 'keyPressed')
	end
end

-- Functions

function keyboard.add(action, key)
	keyboard.keys[action] = key
end

return keyboard
