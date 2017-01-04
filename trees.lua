local trees = {}

function trees.new(x, y, sprite)
  return {
  	worldX = x,
  	worldY = y,
  	worldWidth = 30,
  	worldHeight = 30,
  	drawXOffset = -90,
  	drawYOffset = -190,
    sprite = sprite
  }
end

return trees
