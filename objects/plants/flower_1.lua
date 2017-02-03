return {
	new = function(managers, world, x, y)
		local flower = {}

		-- Basic

		flower.x = x
		flower.y = y
		flower.width = 25
		flower.height = 21

		-- Growth

		flower.time_created = nil
		flower.seconds_to_grow = 5
		flower.grown = false

		-- Collectable

		flower.collectable = false

		-- Graphics

		flower.sprite = managers.graphics.graphics.plants.flower_1_start

		-- Initialisation

		flower.initialise = function()
			world:add(flower, flower.x, flower.y, flower.width, flower.height)
			flower.time_created = tablex.copy(managers.time.time)
		end

		-- Update

		flower.update = function()
			if not flower.grown and managers.time.to_seconds() - managers.time.to_seconds(flower.time_created) > flower.seconds_to_grow then

				-- New dimensions

				local new_height = 36
				flower.sprite = managers.graphics.graphics.plants.flower_1
				flower.y = flower.y - (new_height - flower.height)
				flower.height = new_height

				-- New collision properties

				world:update(flower, flower.x, flower.y, flower.width, flower.height)

				-- New growth properties

				flower.grown = true

				-- New collectable properties

				flower.collectable = true
			end
		end

		return flower

	end
}

