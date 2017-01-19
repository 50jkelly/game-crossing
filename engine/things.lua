local things = {}
local thingsTable = {}

-- Hooks

function things.initialise()
	things.loadGame()
end

function things.loadGame()
	thingsTable = data.plugins.persistence.read('saves/things.lua')
end

function things.saveGame()
	data.plugins.persistence.write(thingsTable, 'saves/things.lua')
end

function things.update(dt)
	local events = data.plugins.events
	local conditions = data.plugins.conditions

	for i, thing in pairs(thingsTable) do

		-- Some functions expect the id of the thing to be part of the thing table, rather than
		-- its index

		thing.id = i

		if thing.canMove then

			-- Save the thing's current position in case we need to move it back

			thing.oldX = thing.x
			thing.oldY = thing.y

			-- If the current movement state is a blocked state then set the current movement
			-- state to idle. Otherwise, clear all blocked states.

			if thing.blockedStates[thing.moveState] then
				thing.moveState = 'idle'
			else
				for _, blocked in pairs(thing.blockedStates) do
					blocked = false
				end
			end

			-- If the thing can move, then update its position accoriding to its movement state

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

			-- Reset the move state so that it must be continually reset on update for the thing
			-- to continue moving

			thing.moveState = 'idle'

			-- If the thing is colliding with something else, then set its position back to its
			-- old position, and add the current movement state to the blocked states so the
			-- thing cannot continue to move in that direction

			local collision = data.plugins.collision
			if collision then
				local collidingWith = collision.colliding(thing, things.toArray())
				if collidingWith and collidingWith.collides then
					thing.x = thing.oldX
					thing.y = thing.oldY
					if thing.moveState ~= idle then
						thing.blockedStates[thing.moveState] = true
					end
				end
			end
		end

		if thing.isAnimated then

			-- Update the thing's sprite according to its animation state

			local animation = data.plugins.animation
			if animation then
				animation.cycle(thing, dt)
			end

			thing.animationState = 'idle'
		end

		-- Handle events if this thing has events associated with it

		if events then
			for _, e in pairs(thing.events or {}) do
				local run = true

				-- Conditions can prevent the event from firing

				if conditions and e.conditions then
					for condition, _ in pairs(e.conditions) do
						local result = conditions[condition](thing, e)
						e.conditions[condition] = result
						run = run and result
					end
				end

				-- Run the event if conditions all passed

				if run and events[e.event] then
					events[e.event].fire(thing, e)
				end
			end
		end
	end
end

-- Functions

function things.toArray()
	local thingsArray = {}
	for i, thing in pairs(thingsTable) do
		table.insert(thingsArray, thing)
		thingsArray[table.getn(thingsArray)].id = i
	end
	return thingsArray
end

function things.setProperty(id, property, value)
	thingsTable[id][property] = value
end

function things.getProperty(id, property)
	return thingsTable[id][property]
end

function things.getThing(id)
	return thingsTable[id]
end

function things.removeThing(id)
	thingsTable[id] = nil
end

function things.addThing(thing)

	-- Generate a new id for this thing

	local prefix = 'thing'
	local i = 1
	local id

	while true do
		if not thingsTable[prefix..i] then
			id = prefix..i
			break
		end
		i = i + 1
	end

	-- Insert the new thing

	thingsTable[id] = thing

	return id
end

return things
