local plugin = {}

-- Public functions

function plugin.cycle(thing, dt)

	if not thing.frames then
		return
	end

	-- Initialise data

	thing.frameCounter = thing.frameCounter or 0
	thing.timeSinceLastFrame = thing.timeSinceLastFrame or 0

	-- Maintain time since last player animation update

	thing.timeSinceLastFrame = thing.timeSinceLastFrame + dt

	-- Cycle the frames

	if thing.timeSinceLastFrame > 1 / (thing.framesPerSecond or 1) then
		thing.timeSinceLastFrame = 0
		thing.frameCounter = thing.frameCounter + 1
		if thing.frameCounter > #thing.frames[thing.animationState] then
			thing.frameCounter = 1
		end

		-- Set the current sprite

		thing.sprite = thing.frames[thing.animationState][thing.frameCounter]
	end
end

return plugin
