local controls = {}

controls.keys = {
	up = "w",
	down = "s",
	left= "a",
	right = "d"
}

function controls.update(data)
	for key, _ in pairs(controls.keys) do
		if love.keyboard.isDown(controls.keys[key]) then
			controls.currentKey = key
			callHook('plugins', 'keyDown')
		end
	end
	return data
end

return controls
