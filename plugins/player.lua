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
end

this.update = function(dt)
	call_hook('plugins', 'player_position_updated', {
		x = this.x,
		y = this.y,
		width = this.width,
		height = this.height,
	})

	call_hook('plugins', 'continue_animation', {
		entity = this,
		dt = dt,
	})

	call_hook('plugins', 'render_entity', {
		x = this.x,
		y = this.y,
		width = this.width,
		height = this.height,
		sprite = this.sprite,
		layer = this.layer,
	})
end

return this
