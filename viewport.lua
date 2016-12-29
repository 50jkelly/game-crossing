local viewport = {}

viewport["x"] = 0
viewport["y"] = 0
viewport["width"] = 600
viewport["height"] = 600

function viewport.update(dt, direction, speed)
	if direction == "up" then
		viewport["y"] = viewport["y"] - (dt * speed)
	end

	if direction == "down" then
		viewport["y"] = viewport["y"] + (dt * speed)
	end

	if direction == "left" then
		viewport["x"] = viewport["x"] - (dt * speed)
	end

	if direction == "right" then
		viewport["x"] = viewport["x"] + (dt * speed)
	end
end

return viewport
