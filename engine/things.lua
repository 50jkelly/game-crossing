local things = {}
local thingsTable = {}
local lastId = nil

-- Hooks

function things.initialise()
	things.loadGame()
end

function things.loadGame()
	local rawData = data.plugins.persistence.read('saves/things.lua')

	-- Split the things into layers

	thingsTable = {{}, {}, {}, {}, {}, {}}
	if rawData then
		for layerIndex, layer in ipairs(rawData) do
			for i, thing in pairs(layer) do
				thingsTable[layerIndex][i] = thing
			end
		end
	end
end

function things.saveGame()
	data.plugins.persistence.write(thingsTable, 'saves/things.lua')
end

function things.update(dt)
	local events = data.plugins.events
	local conditions = data.plugins.conditions
	local renderer = data.plugins.renderer
	local viewport = data.plugins.viewport
	local sprites = data.plugins.sprites
	local animation = data.plugins.animation

	local viewportWidth = love.graphics.getWidth()
	local viewportHeight = love.graphics.getHeight()
	local viewportX = 0
	local viewportY = 0

	if viewport then
		viewportX = viewport.x
		viewportY = viewport.y
	end

	for layerIndex, layer in ipairs(thingsTable) do
		for i, t in pairs(layer) do

			local inViewport = true

			if sprites then
				t.sprite = sprites.getSprite(t.spriteId)
				t.width = t.width or t.sprite.width
				t.height = t.height or t.sprite.height

				if t.lightBlock then
					t.lightBlockSprite = sprites.getSprite(t.lightBlock)
				end

				-- Determine if this thing is in the viewport and can therefore be
				-- drawn. The reason to do this here instead of in the renderer is
				-- to limit the number of times we traverse the entire things array

				inViewport =
					t.x + t.width > viewportX and
					t.x < viewportX + viewportWidth and
					t.y + t.height > viewportY and
					t.y < viewportY + viewportHeight

				if inViewport then
					table.insert(renderer.toDraw[layerIndex], t)
				end
			end

			-- Some functions expect the id of the thing to be part of the thing table, rather than
			-- its index

			t.id = i

			if t.canMove and inViewport then

				-- Save the thing's current position in case we need to move it back

				t.oldX = t.x
				t.oldY = t.y

				-- If the current movement state is a blocked state then set the current movement
				-- state to idle. Otherwise, clear all blocked states.

				if t.blockedStates[t.moveState] then
					t.moveState = 'idle'
				else
					t.blockedStates = {}
				end

				-- If the thing can move, then update its position according to its movement state

				local speed = t.speed * dt
				if t.moveState == 'move_up' then
					t.y = t.y - speed
				end
				if t.moveState == 'move_down' then
					t.y = t.y + speed
				end
				if t.moveState == 'move_left' then
					t.x = t.x - speed
				end
				if t.moveState == 'move_right' then
					t.x = t.x + speed
				end

				-- Reset the move state so that it must be continually reset on
				-- update for the thing to continue moving

				t.moveState = 'idle'

				-- If the thing is colliding with something else, then set its
				-- position back to its old position, and add the current movement
				-- state to the blocked states so the thing cannot continue to
				-- move in that direction

				local collision = data.plugins.collision
				if collision then
					local collidingWith = collision.colliding(t, layer)
					if collidingWith and collidingWith.collides then
						t.x = t.oldX
						t.y = t.oldY
						if t.moveState ~= idle then
							t.blockedStates[t.moveState] = true
						end
					end
				end
			end

			if t.isAnimated and inViewport then

				-- Update the thing's sprite according to its animation state

				if animation then
					animation.cycle(t, dt)
				end

				t.animationState = 'idle'
			end

			-- Handle events if this thing has events associated with it

			if events then
				for _, e in pairs(t.events or {}) do
					local run = true

					-- Conditions can prevent the event from firing

					if conditions and e.conditions then
						for condition, _ in pairs(e.conditions) do
							local result = conditions[condition](t, e)
							e.conditions[condition] = result
							run = run and result
						end
					end

					-- Run the event if conditions all passed

					if run and events[e.event] then
						events[e.event].fire(t, e)
					end
				end
			end
		end
	end
end

-- Functions

function things.setProperty(id, property, value, layer)
	local l = layer or 5
	if thingsTable and thingsTable[l] and thingsTable[l][id] then
		thingsTable[l][id][property] = value
	end
end

function things.getProperty(id, property, layer)
	local l = layer or 5
	if thingsTable and thingsTable[l] and thingsTable[l][id] then
		return thingsTable[l][id][property]
	end
end

function things.getThing(id, layer)
	local l = layer or 5
	return thingsTable[l][id]
end

function things.removeThing(id, layer)
	local l = layer or 5
	thingsTable[l][id] = nil
end

function things.addThing(thing, layer)
	local l = layer or 5

	-- Generate a new id for this thing

	local prefix = 'thing'
	local i = 1
	local id

	if lastId == nil then
		while true do
			if not thingsTable[l][prefix..i] then
				lastId = i
				id = prefix..i
				break
			end
			i = i + 1
		end
	else
		lastId = lastId + 1
		id = prefix..lastId
	end

	-- Insert the new thing

	thing.layer = l
	thingsTable[l][id] = thing

	return id
end

function things.maxLayers()
	return table.getn(thingsTable)
end

return things
