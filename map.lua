TILE_SPIKE_S = 129
TILE_SPIKE_E = TILE_SPIKE_S+3
TILE_WATER_TOP = 135
TILE_WATER = 151
TILE_LAVA_TOP = 137
TILE_LAVA = 153

local lg = love.graphics
local floor = math.floor
local loader = require("AdvTiledLoader.Loader")
loader.path = "maps/"


function loadMap(level)
	current_map = level
	gamestate = STATE_INGAME
	lg.setBackgroundColor(0.1,0.4,0.7)

	map = loader.load(level)
	map.drawObjects = false
	map.useSpriteBatch = true
	fgtiles = map.tileLayers.fg.tileData

	map.enemies = {}
	map.particles = {}
	map.entities = {}
	map.coins = {}

	map.deaths = 0
	map.numcoins = 0
	map.time = 0

	MAPW = map.width*TILEW
	MAPH = map.height*TILEW
	map.startx = 16
	map.starty = 192

	for i,v in ipairs(map.objectLayers.obj.objects) do
		if v.type == "start" then
			map.startx = v.x+8
			map.starty = v.y-4.01
		end
	end

	tx = map.startx - WIDTH/2
	ty = map.starty - HEIGHT/2
	player:respawn()
end

function reloadMap()
	loadMap(current_map)
end

function collidePoint(x,y)
	return isSolid(floor(x/TILEW), floor(y/TILEW))
end


function isSolid(x,y)
	local tile = fgtiles(x,y)
	if tile ~= nil then
		return true
	else
		return false
	end
end


