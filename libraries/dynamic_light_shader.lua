local this = {}
local shader = love.graphics.newShader([[
	extern Image light_map;
	extern Image light_mask;
	extern vec4 ambient_color;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixel_color = Texel(texture, texture_coords);
		vec4 light_color = Texel(light_map, texture_coords);
		vec4 light_block_color = Texel(light_mask, texture_coords);
		vec4 result = (light_color * light_block_color + ambient_color) * pixel_color;
		return min(pixel_color, result);
	}]])

this.send = function(name, value)
	shader:send(name, value)
end

this.get_shader = function()
	return shader
end

return this
