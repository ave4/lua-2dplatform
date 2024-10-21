snd = {}
imgPlayer = {}
local lg = love.graphics
local la = love.audio

function loadImages()
	imgPlayer.small = {}
	imgPlayer.small.stand = lg.newImage('img/tux/small/stand-0.png')
	imgPlayer.small.walk = {}
	for i = 0, 7 do
		imgPlayer.small.walk[i] = love.graphics.newImage('img/tux/small/walk-'..i..'.png')
	end
end

function loadSounds()
	--snd.Burn  	= la.newSource("sound/burn.wav",  "static")
	snd.Jump  	= la.newSource("sound/jump.wav",  "static")
	snd.music = {
  source = la.newSource("sound/fortress.ogg","stream"),
  isMuted = false,
  volume = 0.01
}
end


