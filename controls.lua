local controls = {}

controls.keys = {
	up = "w",
	down = "s",
	left= "a",
	right = "d",
	use = 'e',
	drop = 'r',
	openInventory = 'i',
	saveGame = 'z',
	loadGame = 'l'
}

-- Hooks

function controls.update()
	for key, _ in pairs(controls.keys) do
		if love.keyboard.isDown(controls.keys[key]) then
			controls.currentKeyDown = key
			callHook('plugins', 'keyDown')
		end
	end
end

function love.keypressed(key)
	local action = nil

	for k, _ in pairs(controls.keys) do
		if controls.keys[k] == key then
			action = k
		end
	end

	if action then
		controls.currentKeyPressed = action
		callHook('plugins', 'keyPressed')
	end
end

-- Functions

function controls.add(action, key)
	controls.keys[action] = key
end

return controls
