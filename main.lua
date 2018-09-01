local Gamestate = require "hump.gamestate"

gs = {}
gs.game = {}

require "startend"

local game = gs.game
local lg = love.graphics
local isDown = love.keyboard.isDown

function love.load()
	W, H = 800, 600
	love.window.setMode(W, H)
    Gamestate.registerEvents()
    Gamestate.switch(gs.start)
end

function game:enter()
	player = {x = 0, y = 0, w = 10, h = 10, speed = 300}
	player.x = W/2 - player.w/2
	player.y = H/2 - player.h/2
end

function game:update(dt)
	local p = player
	local p = player
	if p.x < 0 or p.x + p.w > W or p.y < 0 or p.y + p.h > H then
		Gamestate.switch(gs.over)
	end
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
