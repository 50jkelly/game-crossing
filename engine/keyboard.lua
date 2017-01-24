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
	local things = data.plugins.things
	local player = data.plugins.player

	-- Movement

	local isMovementKey =
	keyboard.keyPressed == 'up'
	or keyboard.keyPressed == 'down'
	or keyboard.keyPressed == 'left'
	or keyboard.keyPressed == 'right'

	if data.state == 'game' and things and isMovementKey then
		things.setProperty(player.getId(), 'moveState', 'move_'..keyboard.keyPressed)
		things.setProperty(player.getId(), 'animationState', 'move_'..keyboard.keyPressed)
	end

end

function love.keypressed(key)
	for k, _ in pairs(keyboard.keys) do
		if keyboard.keys[k] == key then
			keyboard.keyPressed = k
			callHook('plugins', 'keypressed', k)
		end
	end
end

function love.keyreleased(key)
	if keyboard.keys[keyboard.keyPressed] == key then
		keyboard.keyPressed = nil
	end
end

return keyboard
