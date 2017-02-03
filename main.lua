-- Globals

tablex = require 'pl.tablex'
utils = require 'pl.utils'
signal = require 'libraries.hump.signal'
utils.import 'pl.func'

initialise_all = bind(tablex.foreach, _1, function(e) e.initialise() end)
update_all = bind(tablex.foreach, _1, function(e, _, dt) e.update(dt) end, _2)
draw_all = bind(tablex.foreach, _1, function(e) love.graphics.draw(e.sprite, e.x, e.y) end)

-- Locals

local managers = {
	graphics = require 'managers.graphics',
	animations = require 'managers.animations',
	objects = require 'managers.objects',
	scenes = require 'managers.scenes',
	keyboard = require 'managers.keyboard',
	mouse = require 'managers.mouse',
	viewport = require 'managers.viewport',
	time = require 'managers.time',
}

-- Load

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	managers.graphics.load()

	managers.viewport.initialise()
	managers.animations.initialise(managers)
	managers.objects.initialise(managers)
	managers.mouse.initialise(managers)
	managers.scenes.initialise(managers)
end

-- Update

function love.update(dt)
	love.window.setTitle('FPS: '..love.timer.getFPS())
	managers.scenes.update(dt)
end

-- Draw

function love.draw()
	managers.scenes.draw()
	managers.mouse.draw()
end
