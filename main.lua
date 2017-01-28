-- Data
data = {
	state = 'game'
}

-- Plugins
data.plugins = {
	animation = require 'plugins.animation',
	clock = require 'plugins.clock',
	collision = require "plugins.collision",
	constants = require 'plugins.constants',
	day_night_cycle = require 'plugins.day_night_cycle',
	fps_display = require 'plugins.fps_display',
	keyboard = require 'plugins.keyboard',
	persistence = require 'plugins.persistence',
	player = require 'plugins.player',
	renderer = require 'plugins.renderer',
	shaders = require 'plugins.shaders',
	sprites = require 'plugins.sprites',
	viewport = require 'plugins.viewport',
}

data.libraries = {
	geometry = require 'libraries.geometry',
	vector = require 'libraries.hump.vector',
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
