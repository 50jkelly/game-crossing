state = 'game'

-- Plugins
plugins = {
	animation = require 'plugins.animation',
	clock = require 'plugins.clock',
	collision = require "plugins.collision",
	day_night_cycle = require 'plugins.day_night_cycle',
	fps_display = require 'plugins.fps_display',
	keyboard = require 'plugins.keyboard',
	persistence = require 'plugins.persistence',
	renderer = require 'plugins.renderer',
	scenes = require 'plugins.scenes',
	viewport = require 'plugins.viewport',
}

libraries = {
	constants = require 'libraries.constants',
	dynamic_light_shader = require 'libraries.dynamic_light_shader',
	geometry = require 'libraries.geometry',
	movement = require 'libraries.movement',
	sprites = require 'libraries.sprites',
	vector = require 'libraries.hump.vector',
}

scenes = {
	world = require 'scenes.world',
}

entities = {
	player = require 'entities.player',
}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	call_hook({ 'libraries', 'plugins', 'scenes', 'entities' }, 'initialise')
	call_hook('libraries', 'load_graphics')
	call_hook('plugins', 'assets_loaded')
end

function love.update(dt)
	call_hook('plugins', 'update', dt)
end

function love.draw()
	call_hook('plugins', 'draw')
	call_hook('plugins', 'draw_ui')
end

function love.resize(width, height)
	call_hook('plugins', 'window_resized', libraries.vector(width, height))
end

function call_hook(collections, method, hookData)
	if type(collections) == 'string' then
		collections = { collections }
	end

	for _, collection in ipairs(collections) do
		for _, value in pairs(_G[collection]) do
			if value[method] ~= nil then
				value[method](hookData)
			end
		end
	end
end
