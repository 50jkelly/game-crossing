local items = {}
items.new = {}

function items.new.jug()
	return {
		name = 'Jug',
		sprite = 'jug',
		charges = 3,
		maxCharges = 3
	}
end

function items.new.seed()
	return {
		name = 'Seed',
		sprite = 'itemSeed',
		placed = 'juvenileFlower'
	}
end

function items.new.juvenileFlower()
	return {
		name = 'Juvenile Flower',
		sprite = 'flower1start',
		layer = 5,
		grow = 'flower',
		growTime = 4 * 60,
		growOffsetY = -15,
		interaction = true,
		water = 0
	}
end

function items.new.flower()
	return {
		name = 'Flower',
		sprite = 'flower1',
		layer = 5,
		interaction = true,
		pickupItems = { 'seed', 'seed' }
	}
end

-- Functions

function items.getRect(itemInstance, playerRect, moveState, previousPosition)
	local sprite = data.plugins.sprites.getSprite(itemInstance.sprite)
	local playerXCenter = playerRect.x + playerRect.width / 2
	local playerYCenter = playerRect.y + playerRect.height / 2
	local margin = 5
	local x, y = 0

	if moveState == 'move_up' then
		x = playerXCenter - (sprite.width / 2)
		y = playerRect.y - sprite.height + margin
	elseif moveState == 'move_down' then
		x = playerXCenter - (sprite.width / 2)
		y = playerRect.y + playerRect.height + margin
	elseif moveState == 'move_left' then
		x = playerRect.x - sprite.width - margin
		y = playerYCenter - (sprite.height / 2)
	elseif moveState == 'move_right' then
		x = playerRect.x + playerRect.width + margin
		y = playerYCenter - (sprite.height / 2)
	elseif moveState == 'idle' then
		local previousPosition = previousPosition or { x = nil, y = nil }
		x = previousPosition.x or playerXCenter - (sprite.width / 2)
		y = previousPosition.y or playerRect.y + playerRect.height + margin
	end

	return x, y, sprite.width, sprite.height
end

return items
