return function(thing, eventData)
	local keyboard = data.plugins.keyboard
	if keyboard then
		return keyboard.currentKeyPressed == 'use'
	end
end
