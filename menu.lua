Menu = {}
Menu.__index = Menu

local lg = love.graphics

function Menu.create(names, functions, escape_function)
	local self = {}
	setmetatable(self, Menu)

	self.names = names
	self.functions = functions
	self.length = #names
	self.escape_function = escape_function

	self.width = 0
	for i,v in ipairs(names) do
		local w = font:getWidth("* "..v.." *")
		self.width = math.max(self.width, w)
	end

	self.height = 32*self.length-9

	self.selected = 1

	return self
end

function Menu:keypressed(k)
	if k == "down" then
		self.selected = self.selected + 1
		--love.audio.play(snd.Blip)
		if self.selected > self.length then
			self.selected = 1
		end
	elseif k == "up" then
		self.selected = self.selected - 1
		--love.audio.play(snd.Blip)
		if self.selected == 0 then
			self.selected = self.length
		end
	elseif k == "return" then
		--love.audio.play(snd.Blip)
		if self.functions[self.selected] then
			self.functions[self.selected](self)
		end
	elseif k == "escape" then
		--love.audio.play(snd.Blip)
		self.escape_function(self)
	end
end

function createMenus()
    local menuItems = {"Играть", "Выход"}
    main_menu = Menu.create(
		menuItems,
		{function() loadMap('hello1.tmx') end,
		 function() love.event.quit() end},

		 function() love.event.quit() end
	)

	local menuItems = {"Продолжить", "Перезапуск", "Опции", "Выход из уровня", "Выход из игры"}
	ingame_menu = Menu.create(
		menuItems,
		{function() gamestate = STATE_INGAME end,
		 function() reloadMap() gamestate = STATE_INGAME end,
		 function() current_menu = options_menu end,
		 function() gamestate = STATE_LEVEL_MENU end,
		 function() love.event.quit() end},

		 function() gamestate = STATE_INGAME end
	)

	current_menu = main_menu
	function main_menu:draw()
		local top = (HEIGHT-self.height)/2
		lg.setColor(1,1,1,1)
		for i=1,self.length do
			if i == self.selected then
				lg.printf("* "..self.names[i].." *", 0, top+(i-1)*(FONT_SIZE+16), WIDTH, "center")
			else
				lg.printf(self.names[i], 0, top+(i-1)*(FONT_SIZE+16), WIDTH, "center")
			end
		end
	end
end

function Menu:draw()
	local top = (HEIGHT-self.height)/2

	lg.setColor(0.3, 0.4, 0.3, 0.4)
	lg.rectangle("fill",(WIDTH-self.width)/2-6, top-6, self.width+12, self.height+18*5)
	lg.setColor(1,1,1,1)

	--lg.setFont(fontBold)
	for i=1,self.length do
		if i == self.selected then
			lg.printf("* "..self.names[i].." *", 0, top+(i-1)*(FONT_SIZE+16), WIDTH, "center")
		else
			lg.printf(self.names[i], 0, top+(i-1)*(FONT_SIZE+16), WIDTH, "center")
		end
	end
end
