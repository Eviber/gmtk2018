local Gamestate = require "hump.gamestate"

gs = {}
gs.game = {}

require "startend"

local game = gs.game
local lg = love.graphics
local isDown = love.keyboard.isDown

function loadSprite()
	image = lg.newImage("sprite.png")
	local width = image:getWidth()
	local height = image:getHeight()
	local frameW = 24
	local frameH = 32

	frames = {}
	for i=0,4 do
		table.insert(frames, lg.newQuad(1 + i*frameW + i, 1, frameW, frameH, width, height))
	end
	currentFrame = 1
	dir = 1
end

function love.load()
	W, H = 800, 600
	love.window.setMode(W, H)
    Gamestate.registerEvents()
    Gamestate.switch(gs.start)
	loadSprite()
end

function game:enter()
	player = {x = 0, y = 0, w = 10, h = 10, speed = 100}
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
		currentFrame = 5
	end
	if isDown("down") then
		player.y = player.y + player.speed * dt
		currentFrame = 1
	end
	if isDown("left") then
		player.x = player.x - player.speed * dt
		if isDown("up") then		currentFrame = 4
		elseif isDown("down") then	currentFrame = 2
		else 						currentFrame = 3 end
		dir = -1
	end
	if isDown("right") then
		player.x = player.x + player.speed * dt
		currentFrame = 3
		if isDown("up") then		currentFrame = 4
		elseif isDown("down") then	currentFrame = 2
		else 						currentFrame = 3 end
		dir = 1
	end
end

function game:draw()
    lg.draw(image, frames[currentFrame], player.x, player.y, 0, dir, 1, 12, 16)
end
