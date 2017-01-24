local dialogs = {}

-- Data

local useCounter = 0
local dialogsList = {
	noWater = {
		x = 10,
		y = 10,
		width = 210,
		height = 35,
		text = 'The jug has run out of water...'
	}
}

-- Hooks

function dialogs.keypressed(key)

	-- Continue/close dialog

	if key == 'use' and data.state == 'dialog' then
		useCounter = useCounter + 1
		if useCounter > 1 then
			data.state = 'game'
			data.dialog = nil
			useCounter = 0
		end
	end

end

-- Functions

function dialogs.open(dialogName)
	data.state = 'dialog'
	data.dialog = dialogsList[dialogName]
end

return dialogs
