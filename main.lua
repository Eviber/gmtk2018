local Gamestate = require "hump.gamestate"
local bump = require "bump/bump"
local peachy = require "peachy.peachy"
local map_utils = require "map_utils"
require "objects"

gs = {}
gs.game = {}
coll = {}
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
	--testEnemy = RifleShooter(1, 100, 100)
	--yourDumb = RifleShooter(2, 200, 100)
	--iHitYou = Brawler(3, 300, 100)
	for i = 0, 10 do
		Brawler(math.random(16, W - 32), math.random(16, H - 32))
	end
	fx_blink = peachy.new("assets/fx_swap.json", lg.newImage("assets/fx_swap.png"), "blink")
	fx_blink:onLoop(function() player.swapping = false player:swap(player.swap_target) end)
	fx_smoke = peachy.new("assets/fx_swap.json", lg.newImage("assets/fx_swap.png"), "smoke")
	fx_smoke:onLoop(function() player.swap_fx = false end)
	

	map = map_utils.strls_to_map(60, 40,
	{
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
		"X--------X-------------------------------------------------X",
		"X--------X-------------------------------------------------X",
		"X--------X-------------------------------------------------X",
		"X--------X-------------------------------------------------X",
		"XXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"XXXXXXXXXX--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--XXXXXXXX",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"XXXXXXXXXXXXXXXXXXXXXXXXXX----XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X----------------------------------------------------------X",
		"X----------------------------------------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X-----------------------X------X---------------------------X",
		"X--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--X",
		"X----------------------------------------------------------X",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	}
	)
	xmap = {}
	for _, i in ipairs(map.tilemap) do
		table.insert(xmap, {})
		for l, val in ipairs(i) do
			table.insert(xmap[#xmap], val.enumstr == "wall" and 1 or 0)
		end
	end
end


function game:enter()
	player:reset()
	love.mouse.setVisible(false)
end

function game:update(dt)
	if player.health <= 0 then
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
