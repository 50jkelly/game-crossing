local lights = {}

lights.shader = love.graphics.newShader([[
	extern Image lightmap;
	extern Image lightBlockMap;
	extern vec4 ambientColor;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixelColor = Texel(texture, texture_coords);
		vec4 lightColor = Texel(lightmap, texture_coords);
		vec4 lightBlockColor = Texel(lightBlockMap, texture_coords);
		vec4 result = (lightColor * lightBlockColor + ambientColor) * pixelColor;
		return min(pixelColor, result);
	}]])

-- Hooks

function lights.preDraw()

	-- Reference any required plugins and set up the canvas we will render the
	-- lightmap to

	local sprites = data.plugins.sprites
	local player = data.plugins.player
	local viewport = getViewport()
	local canvas = love.graphics.newCanvas(viewport.width, viewport.height)

	-- Reference, position and draw the sprite we are using for the player light

	if sprites and player then
		local playerLight = sprites.getSprite('playerLight')
		local playerRect = player.getRect()

		local lightX = playerRect.x +
			(playerRect.width / 2) -
			(playerLight.width / 2)

		local lightY = playerRect.y +
			(playerRect.height / 2) -
			(playerLight.height / 2)

		love.graphics.setCanvas(canvas)
		love.graphics.setBlendMode('alpha')
		love.graphics.setColor(0,0,0,255)

		love.graphics.rectangle(
			'fill',
			viewport.x,
			viewport.y,
			viewport.width,
			viewport.height)

		love.graphics.setColor(data.plugins.constants.white)
		love.graphics.draw(playerLight.sprite, lightX, lightY)
		lights.shader:send('lightmap', canvas)
	end

	-- Calculate the ambient light value based on the current clock time

	local dayNightCycle = data.plugins.dayNightCycle
	local ambientColor = {1, 1, 1, 0}

	if dayNightCycle then
		ambientColor = dayNightCycle.ambientColor
	end

	lights.shader:send('ambientColor', ambientColor)
end

return lights
