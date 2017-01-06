local animation = {}
local frames = {}
local state = nil
local currentSprite = nil
local timeSinceLastFrame = 0
local frameCounter = 1
local framesPerSecond = 8

-- Animations for an entity are broken down into states, and each state is
-- made up of a number of frames.

-- We load the animations of an entity by finding all of its frames on disk
-- and loading them into a table. The frames' filenames are used to determine
-- what state they belong to and what order they appear in the animation.
function animation.load(entityPrefix)
  local files = getFiles(entityPrefix)
  for _, file in ipairs(files) do
    local state = getState(file, entityPrefix)
    addState(state)
    addFrame(state, file)
  end
end

function animation.setInitialState(_state)
  state = _state
  currentSprite = frames[state][frameCounter]
end

function animation.reset()
  frameCounter = 1
  currentSprite = frames[state][frameCounter]
end

function animation.cycleFrames(dt, _state)
	-- Maintain time since last player animation update
	timeSinceLastFrame = timeSinceLastFrame + dt

  state = _state

	-- Cycle the frames
	if timeSinceLastFrame > 1 / framesPerSecond then
		timeSinceLastFrame = 0
		frameCounter = frameCounter + 1
		if frameCounter > table.getn(frames[state]) then
			frameCounter = 1
		end
	end

  -- Set the current sprite
  currentSprite = frames[state][frameCounter]
end

function animation.getCurrentSprite()
  return currentSprite
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

function addState(state)
  if frames[state] == nil then
    frames[state] = {}
  end
end

function addFrame(state, file)
  table.insert(frames[state], love.graphics.newImage(file))
end

return animation
