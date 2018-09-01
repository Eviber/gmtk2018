local Gamestate = require "hump.gamestate"
local map_utils = require "map_utils"
require "objects"

gs = {}
gs.game = {}
require "controls"

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
	W, H = 1280, 960
  love.window.setMode(W, H, {resizable = false})
	Gamestate.registerEvents()
	Gamestate.switch(gs.start)
	player = Player()
	testEnemy = RifleShooter(1, 100, 100)
	yourDumb = RifleShooter(2, 200, 100)
	

  map = map_utils.strls_to_map(80, 60,
  {
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X-----------------------------------XXXXX--------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "X------------------------------------------------------------------------------X",
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    }
  )
end  


function game:enter()
	player:reset()
end

function game:update(dt)
	if player.x < 0 or player.x > W or player.y < 0 or player.y > H then
		Gamestate.switch(gs.over)
	end
	player:move(dt)
end

function game:draw()
  map:draw()
	player:draw()
	for i, entity in pairs(EntitiesList) do
		entity:draw()
	end
end
