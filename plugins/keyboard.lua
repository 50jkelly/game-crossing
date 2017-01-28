local this = {}

this.keys = {
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

this.update = function()
	for key_name, key_code in pairs(this.keys) do
		if love.keyboard.isDown(key_code) then
			call_hook('plugins', 'key_down', key_name)
		end
	end
end

love.keypressed = function(key_code)
	for key_name, _ in pairs(this.keys) do
		if this.keys[key_name] == key_code then
			this.pressed = key_name
			call_hook('plugins', 'key_pressed', key_name)
		end
	end
end

love.keyreleased = function(key_code)
	if this.keys[this.key_pressed] == key_code then
		local key_name = this.pressed
		this.pressed = nil
		call_hook('plugins', 'key_released', key_name)
	end
end

return this
