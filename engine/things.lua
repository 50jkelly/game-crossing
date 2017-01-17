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

		local triggers = data.plugins.triggers
		if triggers then
			local firing = {}
			
			-- Fire triggers that the player is currently standing beside

			for _, otherThing in pairs(thingsTable) do
				if thing.id ~= otherThing.id and otherThing.trigger then
					if overlapping(thing, otherThing, 3) then
						local trigger = triggers[otherThing.trigger]
						if trigger then
							trigger.onFire(otherThing, thing)
							table.insert(firing, otherThing)
						end
					end
				end
			end

			-- Check the old firing table and call the onStop function of any triggers
			-- that this thing is no longer overlapping

			if thing.firing then
				for i, oldf in ipairs(thing.firing) do
					local found = false
					for _, f in ipairs(firing) do
						if oldf.id == f.id then
							found = true
							break
						end
					end
					if not found then
						triggers[oldf.trigger].onStop(oldf, thing)
						table.remove(firing, i)
					end
				end
			end

			-- Store the firing table for the next update

			thing.firing = firing
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

function things.getThing(id)
	return thingsTable[id]
end

return things
