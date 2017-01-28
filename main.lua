-- Data
data = {
	state = 'game'
}

-- Plugins
data.plugins = {
	persistence = require 'engine.persistence',
	viewport = require 'engine.viewport',
	sprites = require 'engine.sprites',
	renderer = require 'engine.renderer',
	shaders = require 'engine.shaders',
	keyboard = require 'engine.keyboard',
	collision = require "engine.collision",
	animation = require 'engine.animation',
	things = require 'engine.things',
	fps_display = require 'engine.fps_display',
	clock = require 'engine.clock',

	constants = require 'scripts.constants',
	dayNightCycle = require 'scripts.dayNightCycle',
	player = require 'scripts.player',
}

data.libraries = {
	vector = require 'libraries.hump.vector',
	geometry = require 'libraries.geometry'
}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	call_hook('libraries', 'initialise')
	call_hook('plugins', 'initialise')
	call_hook('plugins', 'load_graphics')
	call_hook('plugins', 'assets_loaded')
end

function love.update(dt)
	call_hook('plugins', 'update', dt)
end

function love.draw()
	call_hook('plugins', 'pre_draw')
	call_hook('plugins', 'draw')
	call_hook('plugins', 'post_draw')
	call_hook('plugins', 'draw_ui')
end

function love.resize(width, height)
	data.plugins.viewport.width = width
	data.plugins.viewport.height = height
	data.plugins.renderer.initialise()
end

function call_hook(collection, method, hookData)
	for _, value in pairs(data[collection]) do
		if value[method] ~= nil then
			value[method](hookData)
		end
	end
end
