local Gamestate = require "hump.gamestate"
local bump = require "bump/bump"
local peachy = require "peachy.peachy"
local map_utils = require "map_utils"
require "objects"

gs = {}
gs.game = {}
require "controls"
require "startend"

local game = gs.game
local lg = love.graphics
local isDown = love.keyboard.isDown
local cursorImg = lg.newImage("assets/cursor.png")

function love.load()
  tilesize = 16
  W_tiles, H_tiles = 60, 40
	W = W_tiles * tilesize
  H = H_tiles * tilesize
  love.window.setMode(W, H, {resizable = false})
	Gamestate.registerEvents()
	Gamestate.switch(gs.start)
	coll = bump.newWorld()
	player = Player(1, W/2, H/2, 100, 100)
	testEnemy = RifleShooter(1, 100, 100)
	yourDumb = RifleShooter(2, 200, 100)
	iHitYou = Brawler(3, 300, 100)
  fx_blink = peachy.new("assets/fx_swap.json", lg.newImage("assets/fx_swap.png"), "blink")
  fx_blink:onLoop(function() player.swapping = false player:swap(player.swap_target) end)
  fx_smoke = peachy.new("assets/fx_swap.json", lg.newImage("assets/fx_swap.png"), "smoke")
  fx_smoke:onLoop(function() player.swap_fx = false end)
  love.mouse.setVisible(false)

  map = map_utils.strls_to_map(60, 40,
  {
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X-----------------------------------XXXXX------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X-------------------------------------A--------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"X----------------------------------------------------------X",
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
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
	for i, entity in pairs(EntitiesList) do
		entity.idx = i
		entity:update(dt)
	end
  if player.swapping then fx_blink:update(dt) end
  if player.swap_fx then fx_smoke:update(dt) end
end

function draw_mouse_scope()
  local x, y = love.mouse.getX(), love.mouse.getY()
  lg.draw(cursorImg, x - 8, y - 8) --, 0, 1, 16, 16)
end

function game:draw()
  map:draw()
	player:draw()
	for i, entity in pairs(EntitiesList) do
		entity:draw()
	end
	lg.setColor(1,1,1,1)
  if player.swapping then
    fx_blink:draw(player.x - 32, player.y - 32)
  end
  if player.swap_fx then
    fx_smoke:draw(player.x - 32, player.y - 32)
    fx_smoke:draw(player.swap_target.x - 32, player.swap_target.y - 40)
  end
  draw_mouse_scope()
	lg.setFont(startFont)
	lg.print(player.health)
end
