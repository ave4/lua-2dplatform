platform = {}
player = {}

require("resources")
require("map")
require("player")
require("menu")
local floor = math.floor
local lg = love.graphics
local min = math.min
local max = math.max
STATE_MAINMENU = 0
STATE_INGAME = 1

--music.source:setLooping(true)
--love.audio.play(music.source)


function love.load()
  --loader = require("AdvTiledLoader.Loader")
  --loader.path = "maps/"
  --map = loader.load("mine1.tmx")
  lg.setBackgroundColor(0.1,0.1,0.2)
  WIDTH = lg.getWidth()
  HEIGHT = lg.getHeight()
  TILEW = 16 -- TODO: получать с карты
  SCROLL_SPEED = 5
  gamestate = STATE_MAINMENU

  tx = 0
  ty = 0
  ftx = 0
  fty = 0
  FONT_SIZE = 32

  font = love.graphics.newFont("font/liberationsans-bold.ttf", FONT_SIZE)


  lg.setFont(font)

  loadImages()
  loadSounds()
  createMenus()
  player = Player.create()
  --player.frame = 0
  --player.respawn(0,0,1)
  --loadMap(1)
  scale = 2
end

function love.update(dt)
  if gamestate == STATE_INGAME then
    if dt > 0.06 then dt = 0.06 end
    --if player.xspeed == 0 and player.yspeed == 0 then
    --  return end
    player:update(dt)
  --if love.keyboard.isDown("up") then ty = ty + 250*dt end
  --if love.keyboard.isDown("down") then ty = ty - 250*dt end
  --if love.keyboard.isDown("left") then tx = tx + 250*dt end
  --if love.keyboard.isDown("right") then tx = tx - 250*dt end
    map.time = map.time + dt
    local totx = player.x + 6.5 - WIDTH/2
    local toty = player.y + 10 - HEIGHT/2
      tx = min(max(0, tx+(totx-tx)*SCROLL_SPEED*dt), MAPW-WIDTH)
      ty = min(max(0, ty+(toty-ty)*SCROLL_SPEED*dt), MAPH-HEIGHT)
  end
end

function love.keypressed(k)
	if gamestate == STATE_INGAME then
		if k == "space" or k == "z" or k == "x" or k == "right" or k == "left" then
			player:keypressed(k)
        elseif k == "escape" then
			gamestate = STATE_INGAME_MENU
			current_menu = ingame_menu
			ingame_menu.selected = 1
        end
    elseif gamestate == STATE_INGAME_MENU or gamestate == STATE_MAINMENU then
		current_menu:keypressed(k)
    end
end

function love.keyreleased(k)
	if gamestate == STATE_INGAME then
		if k ~= "escape" and k ~= "r" then
			player:keyreleased(k)
		end
	end
end

function love.draw()
  --ftx, fty = math.floor(tx), math.floor(ty)
  if gamestate == STATE_INGAME then
    lg.push()
  --lg.scale(scale)
    drawIngame()
    lg.pop()
    drawIngameHUD()
  elseif gamestate == STATE_INGAME_MENU then
    lg.push()
    drawIngame()
    lg.pop()
    current_menu:draw()
  elseif gamestate == STATE_MAINMENU then
    current_menu:draw()
  end

end

function drawIngame()
  lg.translate(-tx, -ty)
  map:setDrawRange(tx,ty,WIDTH,HEIGHT)
  map:draw()
  player:draw()
end

function drawIngameHUD()
  local time = getTimerString(map.time)
  lg.printf(time, WIDTH-120, 13, 100, "right")
  lg.print("FPS: "..tostring(love.timer.getFPS( )), 10, 25) -- debug only
end

function getTimerString(time)
	local msec = math.floor((time % 1)*100)
	local sec = math.floor(time % 60)
	local min = math.floor(time/60)
	return string.format("%02d'%02d\"%02d",min,sec,msec)
end
