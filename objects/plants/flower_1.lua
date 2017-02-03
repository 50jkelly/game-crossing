return {
	new = function(_managers, x, y)
		local flower = {}
		managers = _managers

		-- Basic

		flower.x = x
		flower.y = y
		flower.width = 25
		flower.height = 21

		-- Growth

		flower.time_created = nil
		flower.seconds_to_grow = 5
		flower.grown = false

		-- Graphics

		flower.sprite = managers.graphics.graphics.plants.flower_1_start

		-- Initialisation

		flower.initialise = function()
			flower.time_created = tablex.copy(managers.time.time)
		end

		-- Update

		flower.update = function()
			if not flower.grown and managers.time.to_seconds() - managers.time.to_seconds(flower.time_created) > flower.seconds_to_grow then
				local new_height = 36
				flower.sprite = managers.graphics.graphics.plants.flower_1
				flower.y = flower.y - (new_height - flower.height)
				flower.height = new_height
				flower.grown = true
			end
		end

		return flower

	end
}

