local lights = {}

lights.shader = love.graphics.newShader([[
	extern Image lightMap;
	extern Image lightBlockMap;
	extern vec4 ambientColor;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixelColor = Texel(texture, texture_coords);
		vec4 lightColor = Texel(lightMap, texture_coords);
		vec4 lightBlockColor = Texel(lightBlockMap, texture_coords);
		vec4 result = (lightColor * lightBlockColor + ambientColor) * pixelColor;
		return min(pixelColor, result);
	}]])

-- Hooks

function lights.preDraw()

	-- Calculate the ambient light value based on the current clock time

	local dayNightCycle = data.plugins.dayNightCycle
	local ambientColor = {1, 1, 1, 0}

	if dayNightCycle then
		ambientColor = dayNightCycle.ambientColor or {1, 1, 1, 0}
	end

	lights.shader:send('ambientColor', ambientColor)
end

return lights
