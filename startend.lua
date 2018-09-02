local Gamestate = require "hump.gamestate"
local bump = require "bump/bump"
local peachy = require "peachy.peachy"

gs.start = {}
gs.over = {}
local items, len
local timer = 0
local clickedPlay = false

local start = gs.start
local over = gs.over

local lg = love.graphics
local isDown = love.keyboard.isDown


function start:init()
	menuHighlight = bump.newWorld()
	menuHighlight:add(1, W/2 - 110, H/2 - 15, 240, 70)
	menuHighlight:add(2, W/2 - 110, H/2 + 45, 240, 70)
	menuHighlight:add(3, W/2 - 110, H/2 + 105, 240, 70)
	fakePlayer = peachy.new("assets/player.json", love.graphics.newImage("assets/player.png"), "walk_D")
	fakePlayer:play()
end

function gs.start:mousepressed(x, y, button, istouch, presses)
	items, len = menuHighlight:queryPoint(x, y)
	if len ~= 0 then
		if items[1] == 1 then
			fakePlayer = peachy.new("assets/fx_swap.json", lg.newImage("assets/fx_swap.png"), "blink")
			fakePlayer:play()
			--Gamestate.switch(gs.game)
			clickedPlay = true
		end
	end
end

function start:update(dt)
	local x, y = love.mouse.getPosition()
	items, len = menuHighlight:queryPoint(x, y) 
	fakePlayer:update(dt)
	if clickedPlay == true then
		timer = timer + dt
		if timer > 0.2 then
			timer = 0
			clickedPlay = false
			fakePlayer = peachy.new("assets/player.json", love.graphics.newImage("assets/player.png"), "walk_D")
			Gamestate.switch(gs.game)
		end
	end
end

function start:draw()
	startFont = lg.setNewFont(50)
	subtitleFont = lg.setNewFont(30)
	smolFont = lg.setNewFont(10)
	lg.setColor(0.5, 0.5, 0.5, 1)
	--lg.rectangle("fill", W/2 - 190, H/2 - 105, 380, 60)
	lg.rectangle("fill", W/2 - 110, H/2 - 15, 240, 70)
	lg.rectangle("fill", W/2 - 110, H/2 + 45, 240, 70)
	lg.rectangle("fill", W/2 - 110, H/2 + 105, 240, 70)
	lg.setFont(startFont)
	lg.setColor(1,1,1,1)
	lg.print("THIS IS A TITLE", W/2 - 180, H/2 - 100)
	lg.setFont(subtitleFont)
	lg.setColor(0,0,0,1)
	lg.print("Play", W/2 - 20, H/2)
	lg.print("How to Play", W/2 - 80, H/2 + 60)
	lg.print("Credits", W/2 - 40, H/2 + 120)
	lg.setFont(smolFont)
	lg.setColor(1,1,1,1)
	--lg.print("Actually this is a placeholder and you need to press Enter to play lul", W/2 - 150, H/2 + 200)
	if len ~= 0 then
		if items[1] == 1 then
			fakePlayer:draw(W/2 - 100, H/2)
		elseif items[1] == 2 then
			fakePlayer:draw(W/2 - 100, H/2 + 60)
		elseif items[1] == 3 then
			fakePlayer:draw(W/2 - 100, H/2 + 120)
		end
	end
end

--[[ Code from Nether Flood for reference
function printGameOver()
	lg.setColor(1, 0, 0, 1)
	gameOverFont = lg.setNewFont(50)
	lg.setFont(gameOverFont)
	lg.print("Game Over !", W/2 - 160, H/2 - 50)
	retryFont = lg.setNewFont(35)
	lg.setFont(retryFont)
	lg.print("Press space to restart", W/2 - 190, H/2 + 50)
end
]]

function over:update(dt)
	if isDown("return") then
		Gamestate.switch(start)
	elseif isDown("escape") then
		love.event.quit()
	end
end

function over:draw()
	lg.setFont(startFont)
	lg.setColor(1,0,0,1)
	lg.print("GAME OVER", W/2 - 130, H/2 - 50)
	love.mouse.setVisible(true)
end
