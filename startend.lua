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
end

function start:draw()
	lg.print("START MENU", 0, 0)
end

function over:update(dt)
	if isDown("return") then
		Gamestate.switch(start)
	elseif isDown("escape") then
		love.event.quit()
	end
end

function over:draw()
	lg.print("GAME OVER", 0, 0)
end
