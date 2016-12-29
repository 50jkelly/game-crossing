-- Animation 
local numberOfFrames = 8
local frameCounter = 1
local framesPerSecond = 10
local timeSinceLastFrame = 0
local frames = {}
frames["up"] = {}
frames["down"] = {}
frames["left"] = {}
frames["right"] = {}
local currentFrames = frames["down"]
local direction = "none"

-- Position
local x = 0
local y = 0
local speed = 2

local function cycleFrames()
	-- Maintain time since last player animation update
	timeSinceLastFrame = timeSinceLastFrame + love.timer.getDelta()	

	-- Cycle the frames
	if timeSinceLastFrame > 1 / framesPerSecond then
		timeSinceLastFrame = 0
		frameCounter = frameCounter + 1
		if frameCounter > numberOfFrames then
			frameCounter = 1
		end
	end
end

local player = {}

function player.load()
	for key,value in pairs(frames) do
		for i=1, numberOfFrames do
			value[i] = love.graphics.newImage("images/player_walk_" .. key .. "_" .. i .. ".png")
		end
	end
end

function player.update(controls)
	-- Determine movement direction based on keyboard input
	direction = "none"

	if love.keyboard.isDown(controls["up"]) then
		direction = "up"
	elseif love.keyboard.isDown(controls["down"]) then
		direction = "down"
	elseif love.keyboard.isDown(controls["left"]) then
		direction = "left"
	elseif love.keyboard.isDown(controls["right"]) then
		direction = "right"
	end

	-- Adjust the player's position based on the direction they are moving
	if direction == "up" then
		y = y - speed
	end

	if direction == "down" then
		y = y + speed
	end

	if direction == "left" then
		x = x - speed
	end

	if direction == "right" then
		x = x + speed
	end

	-- Adjust the player's animation based on the direction they are moving
	if direction ~= "none" then
		currentFrames = frames[direction]
		cycleFrames()
	end
end

function player.draw()
	love.graphics.draw(currentFrames[frameCounter], x, y, 0, 1.5, 1.5, 0, 0)
end

return player
