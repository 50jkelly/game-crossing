local animation = {}

-- Animations for an entity are broken down into states, and each state is
-- made up of a number of frames.

-- We load the animations of an entity by finding all of its frames on disk
-- and loading them into a table. The frames' filenames are used to determine
-- what state they belong to and what order they appear in the animation.
function animation.loadGraphics()
	for _, item in ipairs(data.items) do
		if item.animationPrefix ~= nil then
			item.frames = {}
			item.timeSinceLastFrame = 0
			item.frameCounter = 1
			item.resetAnimation = true
			item.cycleAnimation = false
			local files = getFiles(item.animationPrefix)
			for _, file in ipairs(files) do
				local state = getState(file, item.animationPrefix)
				item.frames = addState(item.frames, state)
				item.frames = addFrame(item.frames, state, file)
			end
		end
	end
end

function animation.update()
	for _, item in ipairs(data.items) do
		if item.resetAnimation then
			reset(item)
		elseif item.cycleAnimation then
			cycleFrames(item, data)
		end
		item.resetAnimation = false
		item.cycleAnimation = false
	end
end

function reset(item)
	item.frameCounter = 1
	item.sprite = item.frames[item.state][item.frameCounter]
end

function cycleFrames(item)
	-- Maintain time since last player animation update
	item.timeSinceLastFrame = item.timeSinceLastFrame + data.dt

	-- Cycle the frames
	if item.timeSinceLastFrame > 1 / item.framesPerSecond then
		item.timeSinceLastFrame = 0
		item.frameCounter = item.frameCounter + 1
		if item.frameCounter > table.getn(item.frames[item.state]) then
			item.frameCounter = 1
		end
	end

	-- Set the current sprite
	item.sprite = item.frames[item.state][item.frameCounter]
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
