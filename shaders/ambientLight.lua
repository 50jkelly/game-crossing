local dayNight = {}
local r = 1.0
local g = 1.0
local b = 1.0

dayNight.shader = love.graphics.newShader([[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
		vec4 pixelColor = Texel(texture, texture_coords);
		return pixelColor;
	}]])

-- Hooks

function dayNight.preDraw()
end

return dayNight
