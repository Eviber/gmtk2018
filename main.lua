local Gamestate = require "hump.gamestate"

local game = {}
local lg = love.graphics
local isDown = love.keyboard.isDown

player = {x = 0, y = 0, w = 10, h = 10, speed = 300}

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function game:update(dt)
	if isDown("up") then
		player.y = player.y - player.speed * dt
	end
	if isDown("down") then
		player.y = player.y + player.speed * dt
	end
	if isDown("left") then
		player.x = player.x - player.speed * dt
	end
	if isDown("right") then
		player.x = player.x + player.speed * dt
	end
end

function game:draw()
    lg.rectangle("fill", player.x, player.y, player.w, player.h)
end
