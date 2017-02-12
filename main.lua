-- Globals

tablex = require 'pl.tablex'
utils = require 'pl.utils'
signal = require 'libraries.hump.signal'
bump = require 'libraries.bump'
utils.import 'pl.func'

tooltip_library = (require 'libraries.tooltip')
inventory = (require 'objects.ui.inventory')()

-- Convenience functions

initialise_all = bind(tablex.foreach, _1, function(e) e.initialise() end)

update_all = bind(tablex.foreach, _1, function(e, _, _2) e.update(_2) end, _2)

draw_all = bind(tablex.foreach, _1, function(e)
	if not e.hidden then
		love.graphics.draw(e.sprite, e.x, e.y)
		if e.draw then
			e.draw()
		end
	end
end)

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
	items = require 'managers.items',
}

-- Load

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	font = love.graphics.newFont('fonts/Mufferaw.otf', 14)
	managers.graphics.load()

	managers.viewport.initialise()
	managers.animations.initialise(managers)
	managers.objects.initialise(managers)
	managers.items.initialise(managers)

	inventory.initialise(managers.graphics.graphics.ui.inventory.trash)

	managers.scenes.initialise(managers)
end

-- Update

function love.update(dt)
	love.window.setTitle('FPS: '..love.timer.getFPS())
	managers.scenes.update(dt)
end

-- Draw

function love.draw()
	love.graphics.setFont(font)
	managers.scenes.draw()
end
