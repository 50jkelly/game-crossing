local animation = {}

-- Animations for an entity are broken down into states, and each state is
-- made up of a number of frames.

-- We load the animations of an entity by finding all of its frames on disk
-- and loading them into a table. The frames' filenames are used to determine
-- what state they belong to and what order they appear in the animation.
function animation.loadGraphics()
	local entities = concat(data.staticEntities, data.dynamicEntities)
	for _, entity in ipairs(entities) do
		if entity.animationPrefix ~= nil then
			entity.frames = {}
			entity.timeSinceLastFrame = 0
			entity.frameCounter = 1
			entity.resetAnimation = true
			entity.cycleAnimation = false
			local files = getFiles(entity.animationPrefix)
			for _, file in ipairs(files) do
				local state = getState(file, entity.animationPrefix)
				entity.frames = addState(entity.frames, state)
				entity.frames = addFrame(entity.frames, state, file)
			end
		end
	end
end

function animation.update()
	local entities = concat(data.staticEntities, data.dynamicEntities)
	for _, entity in ipairs(entities) do
		if entity.resetAnimation then
			reset(entity)
		elseif entity.cycleAnimation then
			cycleFrames(entity, data)
		end
		entity.resetAnimation = false
		entity.cycleAnimation = false
	end
end

function reset(entity)
	entity.frameCounter = 1
	entity.sprite = entity.frames[entity.state][entity.frameCounter]
end

function cycleFrames(entity)
	-- Maintain time since last player animation update
	entity.timeSinceLastFrame = entity.timeSinceLastFrame + data.dt

	-- Cycle the frames
	if entity.timeSinceLastFrame > 1 / entity.framesPerSecond then
		entity.timeSinceLastFrame = 0
		entity.frameCounter = entity.frameCounter + 1
		if entity.frameCounter > table.getn(entity.frames[entity.state]) then
			entity.frameCounter = 1
		end
	end

	-- Set the current sprite
	entity.sprite = entity.frames[entity.state][entity.frameCounter]
end

-- Private functions
function getFiles(entityPrefix)
  local files = {}
  local p = io.popen('find images -type f | grep "'..entityPrefix..'"')
  for file in p:lines() do
    table.insert(files, file)
  end
  return files
end

function getState(file, entityPrefix)
  return string.match(file, entityPrefix..'_(.+)_%d')
end

function addState(frames, state)
  if frames[state] == nil then
    frames[state] = {}
  end
  return frames
end

function addFrame(frames, state, file)
  table.insert(frames[state], love.graphics.newImage(file))
  return frames
end

return animation
