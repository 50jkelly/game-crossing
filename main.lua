tablex = require 'pl.tablex'
signal = require 'libraries.hump.signal'

local managers = {
	graphics = require 'managers.graphics',
	animations = require 'managers.animations',
	objects = require 'managers.objects',
	scenes = require 'managers.scenes',
	keyboard = require 'managers.keyboard',
	viewport = require 'managers.viewport',
	time = require 'managers.time',
}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	managers.graphics.load()

	managers.viewport.initialise()
	managers.animations.initialise(managers)
	managers.objects.initialise(managers)
	managers.scenes.initialise(managers)
end

function love.update(dt)
	-- FPS
	love.window.setTitle('FPS: '..love.timer.getFPS())

	managers.scenes.update(dt)
end

function love.draw()
	managers.scenes.draw()
end
