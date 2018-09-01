local Gamestate = require "hump.gamestate"

gs.start = {}
gs.over = {}

local start = gs.start
local over = gs.over

local lg = love.graphics
local isDown = love.keyboard.isDown

function start:update(dt)
	if isDown("return") then
		Gamestate.switch(gs.game)
	end
	local x, y = love.mouse.getPosition()
end

function start:draw()
	startFont = lg.setNewFont(50)
	subtitleFont = lg.setNewFont(30)
	smolFont = lg.setNewFont(10)
	lg.setFont(startFont)
	lg.setColor(1,1,1,1)
	lg.print("THIS IS A TITLE", W/2 - 180, H/2 - 100)
	lg.setFont(subtitleFont)
	lg.print("Play", W/2 - 20, H/2)
	lg.print("How to Play", W/2 - 80, H/2 + 50)
	lg.print("Credits", W/2 - 40, H/2 + 100)
	lg.setFont(smolFont)
	lg.print("Actually this is a placeholder and you need to press Enter to play lul", W/2 - 150, H/2 + 200)
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
end
