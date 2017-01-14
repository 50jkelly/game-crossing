local plugin = {
	backgroundColor = {0, 55, 150, 255},
	borderColor = {255, 255, 255, 255},
	textColor = {255, 255, 255, 255},
	messageBoxes = {}
}

-- Hooks

function plugin.trigger1Fire(item)
	local text = 'The player is not holding anything.'
	if item then
		text = 'The player is holding '..item.amount..' '..item.name..'s.'
	end
		
	table.insert(plugin.messageBoxes, {
		x = 10,
		y = 10,
		width = data.screenWidth - 10,
		height = 30,
		text = text
	})
end

function plugin.trigger1Stop(item)
	plugin.messageBoxes = {}
end

return plugin
