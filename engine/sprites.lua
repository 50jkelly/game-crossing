local sprites = {}
local spritesTable = {}

function sprites.loadGraphics()
	loadSprite('cursor', 'images/cursor.png')
	loadSprite('itemBook', 'images/item_book.png')
	loadSprite('itemSeed', 'images/item_seed.png')
	loadSprite('worldItemSeed', 'images/worldItemSeed.png')

	loadSprite('grass1', 'images/grass1.png')
	loadSprite('flower1', 'images/flower1.png')
	loadSprite('tree1Bottom', 'images/trees/tree1Bottom.png')
	loadSprite('tree1Top', 'images/trees/tree1Top.png')

	-- Lightmaps

	loadSprite('playerLight', 'images/lightmaps/playerLight.png')
	loadSprite('flower1Light', 'images/lightmaps/flower1Light.png')
	loadSprite('tree1TopLightBlock', 'images/lightmaps/tree1TopLightBlock.png')

	loadSprite('player_walk_down_1', 'images/player_walk_down_1.png')
	loadSprite('player_walk_down_2', 'images/player_walk_down_2.png')
	loadSprite('player_walk_down_3', 'images/player_walk_down_3.png')
	loadSprite('player_walk_down_4', 'images/player_walk_down_4.png')
	loadSprite('player_walk_down_5', 'images/player_walk_down_5.png')
	loadSprite('player_walk_down_6', 'images/player_walk_down_6.png')
	loadSprite('player_walk_down_7', 'images/player_walk_down_7.png')
	loadSprite('player_walk_down_8', 'images/player_walk_down_8.png')
	loadSprite('player_walk_left_1', 'images/player_walk_left_1.png')
	loadSprite('player_walk_left_2', 'images/player_walk_left_2.png')
	loadSprite('player_walk_left_3', 'images/player_walk_left_3.png')
	loadSprite('player_walk_left_4', 'images/player_walk_left_4.png')
	loadSprite('player_walk_left_5', 'images/player_walk_left_5.png')
	loadSprite('player_walk_left_6', 'images/player_walk_left_6.png')
	loadSprite('player_walk_left_7', 'images/player_walk_left_7.png')
	loadSprite('player_walk_left_8', 'images/player_walk_left_8.png')
	loadSprite('player_walk_right_1', 'images/player_walk_right_1.png')
	loadSprite('player_walk_right_2', 'images/player_walk_right_2.png')
	loadSprite('player_walk_right_3', 'images/player_walk_right_3.png')
	loadSprite('player_walk_right_4', 'images/player_walk_right_4.png')
	loadSprite('player_walk_right_5', 'images/player_walk_right_5.png')
	loadSprite('player_walk_right_6', 'images/player_walk_right_6.png')
	loadSprite('player_walk_right_7', 'images/player_walk_right_7.png')
	loadSprite('player_walk_right_8', 'images/player_walk_right_8.png')
	loadSprite('player_walk_up_1', 'images/player_walk_up_1.png')
	loadSprite('player_walk_up_2', 'images/player_walk_up_2.png')
	loadSprite('player_walk_up_3', 'images/player_walk_up_3.png')
	loadSprite('player_walk_up_4', 'images/player_walk_up_4.png')
	loadSprite('player_walk_up_5', 'images/player_walk_up_5.png')
	loadSprite('player_walk_up_6', 'images/player_walk_up_6.png')
	loadSprite('player_walk_up_7', 'images/player_walk_up_7.png')
	loadSprite('player_walk_up_8', 'images/player_walk_up_8.png')
end

function sprites.getSprite(id)
	return spritesTable[id]
end

function loadSprite(id, path)
	local sprite = love.graphics.newImage(path)
	local width, height = sprite:getDimensions()

	spritesTable[id] = {
		sprite = sprite,
		width = width,
		height = height
	}
end

return sprites
