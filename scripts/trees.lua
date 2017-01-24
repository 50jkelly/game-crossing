local trees = {}

function trees.add(x, y)
	local things = data.plugins.things

	table.insert(things.thingsTable, {
		x = x,
		y = y,
		sprite = 'tree1Bottom',
		collides = true,
		layer = 5,
		speed = 0,
		blockedStates = {},
		framesPerSecond = 1,
		frames = {
			idle = { 'tree1Bottom' }
		}
	})

	table.insert(things.thingsTable, {
		x = x - 60,
		y = y - 180,
		sprite = 'tree1Top',
		lightBlockSprite = 'tree1TopLightBlock',
		collides = false,
		layer = 6,
		speed = 0,
		blockedStates = {},
		framesPerSecond = 1,
		frames = {
			idle = { 'tree1Top' }
		}
	})
end

return trees
