local things = {}
local minutes
local lastMinutes

-- Hooks

function things.assetsLoaded()
	things.loadGame()
	things.toRemove = {}
end

function things.loadGame()
	things.thingsTable = data.plugins.persistence.read('saves/things.lua')
	lastMinutes = nil
end

function things.saveGame()
	data.plugins.persistence.write(things.thingsTable, 'saves/things.lua')
end

function things.update(dt)
	local events = data.plugins.events
	local conditions = data.plugins.conditions
	local renderer = data.plugins.renderer
	local sprites = data.plugins.sprites
	local animation = data.plugins.animation
	local collision = data.plugins.collision
	local inventory = data.plugins.inventory
	local items = data.plugins.items
	local clock = data.plugins.clock
	local player = data.plugins.player
	local viewport = getViewport()

	-- Clock

	minutes = clock.getMinutes()
	local minutesDelta = minutes - (lastMinutes or minutes)

	-- Player interaction

	player.canInteract = {}

	-- Things

	for i, thing in ipairs(things.thingsTable) do

		thing.width = thing.width or sprites.getSprite(thing.sprite).width
		thing.height = thing.height or sprites.getSprite(thing.sprite).height

		if overlapping(thing, viewport) then
			table.insert(renderer.toDraw[thing.layer], thing)
			thing.id = i

			-- State check

			if data.state ~= 'game' then
				return
			end

			-- Movement

			local speed = (thing.speed or 0) * dt
			local positionChange = { x = {}, y = {}}
			positionChange['y']['move_up'] = thing.y - speed
			positionChange['y']['move_down'] = thing.y + speed
			positionChange['x']['move_left'] = thing.x - speed
			positionChange['x']['move_right'] = thing.x + speed

			thing.oldX = thing.x
			thing.oldY = thing.y
			thing.blockedStates = thing.blockedStates or {}
			thing.moveState = thing.blockedStates[thing.moveState] or thing.moveState
			thing.x = positionChange['x'][thing.moveState] or thing.x
			thing.y = positionChange['y'][thing.moveState] or thing.y
			thing.moveState = 'idle'
			thing.blockedStates = {}

			-- Collision detection

			local collisionPosition = {}
			local newMoveState = {}
			collisionPosition['true'] = { x = thing.oldX, y = thing.oldY }
			collisionPosition['false'] = { x = thing.x, y = thing.y }
			newMoveState['true'] = 'idle'
			newMoveState['false'] = thing.moveState

			local collidingWith = tostring((collision.colliding(thing, things.thingsTable)) ~= nil)
			thing.x = collisionPosition[collidingWith].x
			thing.y = collisionPosition[collidingWith].y
			thing.blockedStates[thing.moveState] = newMoveState[collidingWith]

			-- Animation

			animation.cycle(thing, dt)
			thing.animationState = 'idle'

			-- Water consumption

			if thing.water then
				thing.water = math.max(0, thing.water - minutesDelta)
			end

			-- Growth

			if thing.grow and thing.growTime then

				if thing.water and thing.water == 0 then
					thing.growTime = thing.growTime - (minutesDelta / 10)
				else
					thing.growTime = thing.growTime - minutesDelta
				end

				if thing.growTime < 0 then
					local newThing = copyThing(
						items[thing.grow],
						thing.x + (thing.growOffsetX or 0),
						thing.y + (thing.growOffsetY or 0))
					table.insert(things.toRemove, thing)
					table.insert(things.thingsTable, newThing)
				end
			end

			-- Player interaction

			thing.inRange = false
			local interactRange = things.getProperty(player.getId(), 'interactRange')
			if thing.interaction and player.inRange(thing, interactRange) then
				table.insert(player.canInteract, thing)
				thing.inRange = true
			end

		end
	end

	-- Cursor sprite

	local slot = inventory.getSlots()[inventory.highlightedSlot]
	local item = items[slot.item]
	renderer.cursorSprite = nil
	if item and item.placed then
		renderer.cursorSprite = items[item.placed].sprite
	end

	-- Thing removal

	for i, thing in ipairs(things.toRemove) do
		table.remove(things.thingsTable, thing.id)
	end

	for i, thing in ipairs(things.toRemove) do
		table.remove(things.toRemove, i)
	end

	-- Clock

	lastMinutes = minutes

end

-- Functions

function things.setProperty(id, property, value)
	if things.thingsTable[id] then
		things.thingsTable[id][property] = value
	end
end

function things.getProperty(id, property)
	if things.thingsTable[id] then
		return things.thingsTable[id][property]
	end
end

function things.getThing(id)
	return things.thingsTable[id]
end

function things.removeThing(id)
	things.thingsTable[id] = nil
end

return things
