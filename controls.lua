local controls = {}

controls.keys = {
	up = "w",
	down = "s",
	left= "a",
	right = "d",
	use = 'e',
	openInventory = 'i',
	inventorySlot1 = '1',
	inventorySlot2 = '2',
	inventorySlot3 = '3',
	inventorySlot4 = '4',
	inventorySlot5 = '5',
	inventorySlot6 = '6',
	inventorySlot7 = '7',
	inventorySlot8 = '8',
	inventorySlot9 = '9',
	inventorySlot10 = '0',
	saveGame = 'z',
	loadGame = 'l'
}

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


return controls
