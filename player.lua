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

local function cycleFrames(dt)
	-- Maintain time since last player animation update
	timeSinceLastFrame = timeSinceLastFrame + dt

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
player["speed"] = 100
player["direction"] = "none"

function player.load()
	for key,value in pairs(frames) do
		for i=1, numberOfFrames do
			value[i] = love.graphics.newImage("images/player_walk_" .. key .. "_" .. i .. ".png")
		end
	end
end

function player.update(dt)
	-- Determine movement direction based on keyboard input
	player["direction"] = "none"

	if love.keyboard.isDown(controls["up"]) then
		player["direction"] = "up"
	elseif love.keyboard.isDown(controls["down"]) then
		player["direction"] = "down"
	elseif love.keyboard.isDown(controls["left"]) then
		player["direction"] = "left"
	elseif love.keyboard.isDown(controls["right"]) then
		player["direction"] = "right"
	end

	if player["direction"] ~= "none" then
		currentFrames = frames[player["direction"]]
		cycleFrames(dt)
	end
end

function player.draw(viewport)
	local x = viewport["width"] / 2
	local y = viewport["height"] / 2
	love.graphics.draw(currentFrames[frameCounter], x, y, 0, 1.5, 1.5, 0, 0)
end

return player
