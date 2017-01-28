local this = {}

local constants
local dynamic_light_shader
local sprites

local light_map
local light_mask
local ambient_color
local diffuse_canvas
local layers

local draw_panel = function(x, y, width, height, background_color, border_color)
	love.graphics.setColor(background_color)
	love.graphics.rectangle("fill", x, y, width, height, 5, 5)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", x, y, width, height, 5, 5)
	love.graphics.setColor(255, 255, 255, 255)
end

local clear_canvas = function(canvas, color)
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', 0, 0, viewport.width, viewport.height)
end

local use_canvas = function(canvas, mode, func, alpha)
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode(mode, (alpha or nil))
	func()
	love.graphics.setBlendMode('alpha')
	love.graphics.setShader()
	love.graphics.setCanvas()
end

this.initialise = function()
	constants = libraries.constants
	dynamic_light_shader = libraries.dynamic_light_shader
	sprites = libraries.sprites

	diffuse_canvas = love.graphics.newCanvas(viewport.width, viewport.height)
	light_map = love.graphics.newCanvas(viewport.width, viewport.height)
	light_mask = love.graphics.newCanvas(viewport.width, viewport.height)
	layers = {{}, {}, {}, {}, {}, {}}
	ambient_color = {1, 1, 1, 0}
end

this.viewport_updated = function(new_rectangle)
	viewport = new_rectangle
end

this.ambient_color_updated = function(color)
	ambient_color = color
end

this.render_entity = function(entity)
	table.insert(layers[entity.layer], entity)
end

this.draw = function()

	clear_canvas(light_map, constants.black)
	clear_canvas(light_mask, constants.white)
	clear_canvas(diffuse_canvas, constants.white)

	for layer_index, layer in pairs(layers) do

		-- Entity sort

		table.sort(layer, function(a, b)
			return a.height + a.y < b.height + b.y
		end)

		love.graphics.push()
		love.graphics.translate(-viewport.x, -viewport.y)

		for _, entity in ipairs(layer) do

			-- Render diffuse canvas

			use_canvas(diffuse_canvas, 'alpha', function()
				love.graphics.draw(sprites.get_sprite(entity.sprite).sprite, entity.x, entity.y)
				love.graphics.setColor(constants.white)
			end)


			-- Render light map

			use_canvas(light_map, 'add', function()
				if entity.light_sprite then
					love.graphics.draw(
						entity.light_sprite,
						geometry.get_center(entity).x - geometry.get_center(entity.light_sprite).x + (entity.light_offset.x or 0),
						geometry.get_center(entity).y - geometry.get_center(entity.light_sprite).y + (entity.light_offset.y or 0))
				end
			end)

			-- Render light mask

			use_canvas(light_mask, 'alpha', function()
				if entity.light_mask_sprite then
					love.graphics.draw(entity.light_mask_sprite, entity.x, entity.y)
				end
			end)
		end


		-- Render shader

		dynamic_light_shader.send('light_map', light_map)
		dynamic_light_shader.send('light_mask', light_mask)
		dynamic_light_shader.send('ambient_color', ambient_color)

		use_canvas(nil, 'alpha', function()
			love.graphics.setShader(dynamic_light_shader.get_shader())
			love.graphics.draw(diffuse_canvas, viewport.x, viewport.y)
		end, 'premultiplied')

		love.graphics.pop()

		-- Reset layer

		layers[layer_index] = {}
	end
end

this.draw_ui = function()
end

return this
