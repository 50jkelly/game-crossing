-- Animation data: TO BE MOVED
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

-- Player data
local player = {
	id = "player",
	speed = 100,
	direction = "none",
	worldX = 100,
	worldY = 100,
	worldWidth = 20,
	worldHeight = 10,
	drawXOffset = 0,
	drawYOffset = -16
}

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

function player.load()
	for key,value in pairs(frames) do
		for i=1, numberOfFrames do
			value[i] = love.graphics.newImage("images/player_walk_" .. key .. "_" .. i .. ".png")
		end
	end
end

-- Collision functions: TO BE MOVED
function colliding(item1, item2)
	return not (item1.worldX + item1.worldWidth < item2.worldX
		or item2.worldX + item2.worldWidth < item1.worldX
		or item1.worldY + item1.worldHeight < item2.worldY
		or item2.worldY + item2.worldHeight < item1.worldY)
end

function checkCollisions(mainItem, items)
	for _, item in ipairs(items) do
		local skip = mainItem.id == item.id
		if not skip and colliding(mainItem, item) then return true end
	end
	return false
end

function player.update(dt, controls, items)
	-- Determine movement direction based on keyboard input
	player["direction"] = "none"

	-- Initialise the future player so we can do collision predictions
	local futurePlayer = {
		id = player.id,
		worldWidth = player.worldWidth,
		worldHeight = player.worldHeight,
		worldX = player.worldX,
		worldY = player.worldY
	}

	if love.keyboard.isDown(controls["up"]) then
		player["direction"] = "up"
		futurePlayer.worldY = player.worldY - (player.speed * dt)
	elseif love.keyboard.isDown(controls["down"]) then
		player["direction"] = "down"
		futurePlayer.worldY = player.worldY + (player.speed * dt)
	elseif love.keyboard.isDown(controls["left"]) then
		player["direction"] = "left"
		futurePlayer.worldX = player.worldX - (player.speed * dt)
	elseif love.keyboard.isDown(controls["right"]) then
		player["direction"] = "right"
		futurePlayer.worldX = player.worldX + (player.speed * dt)
	end

	-- Commit the future player's location to the current player's if the future
	-- player's movement does not cause a collision
	if not checkCollisions(futurePlayer, items) then
		player.worldX = futurePlayer.worldX
		player.worldY = futurePlayer.worldY
	end

	if player["direction"] ~= "none" then
		currentFrames = frames[player["direction"]]
		cycleFrames(dt)
	end

	player.sprite = currentFrames[frameCounter]
end

return player
