local trees = {}

function trees.initialise(data)
	local tree1Sprite = love.graphics.newImage("images/tree1.png")

	-- Plant a forest
	for i=1, 200, 1 do
		local x = math.random(-1000, 1000)
		local y = math.random(-1000, 1000)
		table.insert(data.items, newTree(x, y, tree1Sprite))
	end

	return data
end

function newTree(x, y, sprite)
  return {
  	x = x,
  	y = y,
  	width = 30,
  	height = 30,
  	drawXOffset = -90,
  	drawYOffset = -190,
    sprite = sprite
  }
end

return trees
