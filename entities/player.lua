local this = {}
local movement
local delta_time

this.initialise = function()
	-- Libraries
	movement = data.libraries.movement

	-- Position
	this.x = 0
	this.y = 0
	this.width = 20
	this.height = 26
	this.speed = 100

	-- Animation
	this.animation_state = 'player_walk_down'
	this.frames_per_second = 12
	call_hook('plugins', 'enable_animation', this)

	-- Rendering
	this.layer = 5

	-- Scene
	call_hook('plugins', 'add_to_scene', { scene = 'world', entity = this })
end

this.update = function(dt)
	delta_time = dt
	call_hook('plugins', 'player_position_updated', this)
	call_hook('plugins', 'continue_animation', { entity = this, dt = dt, })
	call_hook('plugins', 'render_entity', this)
end

this.key_down = function(key)
	movement.move(this, key, delta_time)
end

return this
