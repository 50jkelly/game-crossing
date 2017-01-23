local things = {}
local rawData = {}
local thingsTable = {}
local lastId = nil

-- Hooks

function things.assetsLoaded()
	things.loadGame()
end

function things.loadGame()
	thingsTable = {}
	rawData = data.plugins.persistence.read('saves/things.lua')

	for _, thing in ipairs(rawData) do
		things.addThing(thing)
	end
end

function things.saveGame()
	rawData = {}
	for _, thing in ipairs(thingsTable) do
		if thing.type then
			data.plugins[thing.type].save(thing, rawData)
		end
	end
	data.plugins.persistence.write(rawData, 'saves/things.lua')
end

function things.update(dt)
	local events = data.plugins.events
	local conditions = data.plugins.conditions
	local renderer = data.plugins.renderer
	local sprites = data.plugins.sprites
	local animation = data.plugins.animation

	local viewport = getViewport()

	for _, thing in ipairs(thingsTable) do

		local inViewport =
		thing.x + thing.width > viewport.x and
		thing.x < viewport.x + viewport.width and
		thing.y + thing.height > viewport.y and
		thing.y < viewport.y + viewport.height

		if inViewport then
			table.insert(renderer.toDraw[thing.layer], thing)
		end

		if thing.canMove and inViewport then

			-- Save the thing's current position in case we need to move it back

			thing.oldX = thing.x
			thing.oldY = thing.y

			-- If the current movement state is a blocked state then set the current movement
			-- state to idle. Otherwise, clear all blocked states.

			if thing.blockedStates[thing.moveState] then
				thing.moveState = 'idle'
			else
				thing.blockedStates = {}
			end

			-- If the thing can move, then update its position according to its movement state

			local speed = thing.speed * dt
			if thing.moveState == 'move_up' then
				thing.y = thing.y - speed
			end
			if thing.moveState == 'move_down' then
				thing.y = thing.y + speed
			end
			if thing.moveState == 'move_left' then
				thing.x = thing.x - speed
			end
			if thing.moveState == 'move_right' then
				thing.x = thing.x + speed
			end

			-- Reset the move state so that it must be continually reset on
			-- update for the thing to continue moving

			thing.moveState = 'idle'

			-- If the thing is colliding with something else, then set its
			-- position back to its old position, and add the current movement
			-- state to the blocked states so the thing cannot continue to
			-- move in that direction

			local collision = data.plugins.collision
			if collision then
				local collidingWith = collision.colliding(thing, thingsTable)
				if collidingWith and collidingWith.collides then
					thing.x = thing.oldX
					thing.y = thing.oldY
					if thing.moveState ~= idle then
						thing.blockedStates[thing.moveState] = true
					end
				end
			end
		end

		if thing.isAnimated and inViewport then

			-- Update the thing's sprite according to its animation state

			if animation then
				animation.cycle(thing, dt)
			end

			thing.animationState = 'idle'
		end

		-- Handle events if this thing has events associated with it

		if events then
			for _, event in ipairs(thing.events or {}) do
				events[event].fire(thing, event)
			end
		end
	end
end

-- Functions

function things.setProperty(id, property, value)
	if thingsTable and thingsTable and thingsTable[id] then
		thingsTable[id][property] = value
	end
end

function things.getProperty(id, property)
	if thingsTable and thingsTable and thingsTable[id] then
		return thingsTable[id][property]
	end
end

function things.getThing(id)
	return thingsTable[id]
end

function things.removeThing(id)
	thingsTable[id] = nil
end

function things.addThing(thing)
	if thing.type then
		data.plugins[thing.type].load(thing, thingsTable)
		thing.id = #thingsTable
	end
end

return things
