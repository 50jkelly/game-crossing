local sprites = {}
local spritesTable = {}

function sprites.loadGraphics()
	loadSprite('cursor', 'images/cursor.png')
	loadSprite('itemBook', 'images/item_book.png')
	loadSprite('itemSeed', 'images/item_seed.png')
	loadSprite('worldItemSeed', 'images/worldItemSeed.png')
	loadSprite('tree1', 'images/tree1.png')
	loadSprite('plant_1', 'images/plant_1.png')
	loadSprite('grass', 'images/grass.png')

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
	spritesTable[id] = love.graphics.newImage(path)
end

return sprites
