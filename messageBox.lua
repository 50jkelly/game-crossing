local messageBox = {
	backgroundColor = {0, 55, 150, 255},
	borderColor = {255, 255, 255, 255},
	textColor = {255, 255, 255, 255}
}

function messageBox.drawUI()
	for _, plugin in pairs(data.plugins) do
		if plugin.messageBoxes then
			for _, box in ipairs(plugin.messageBoxes) do
				love.graphics.setColor(messageBox.backgroundColor)
				love.graphics.rectangle("fill", box.x, box.y, box.width, box.height, 5, 5)
				love.graphics.setColor(messageBox.borderColor)
				love.graphics.rectangle("line", box.x, box.y, box.width, box.height, 5, 5)
				love.graphics.setColor(messageBox.textColor)
				love.graphics.printf(box.text, box.x + 10, box.y + 10, box.width - 15)
				love.graphics.setColor(255, 255, 255, 255)
			end
		end
	end
end

return messageBox
