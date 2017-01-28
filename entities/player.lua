local this = {}

this.initialise = function()
	-- Position
	this.x = 0
	this.y = 0
	this.width = 20
	this.height = 26

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
	call_hook('plugins', 'player_position_updated', this)
	call_hook('plugins', 'continue_animation', { entity = this, dt = dt, })
	call_hook('plugins', 'render_entity', this)
end

return this
