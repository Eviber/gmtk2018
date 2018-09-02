--[[
Critter = Class{
    init = function(self, pos, img)
        self.pos = pos
        self.img = img
    end,
    speed = 5
}

function Critter:update(dt, player)
    -- see hump.vector
    local dir = (player.pos - self.pos):normalize_inplace()
    self.pos = self.pos + dir * Critter.speed * dt
end

function Critter:draw()
    love.graphics.draw(self.img, self.pos.x, self.pos.y)
end
]]--

TILESIZE = 16

local Vector = require "hump.vector"
local Class = require "hump.class"
local lg = love.graphics
require "collide"
--local debug = require "debug"

map_utils = {}

tileset = {
	wall = lg.newImage("assets/tmp/tmp_wall.png"),
	floor = lg.newImage("assets/tmp/tmp_floor.png"),
  err = lg.newImage("assets/tmp/tmp_error.png")
}

Tile = Class{
	tilesize = TILESIZE,
	init = function(self, x, y, enumstr, tile_img)
		self.indices = Vector.new(x, y)
		self.pos = Vector.new((x - 1) * self.tilesize, (y - 1) * self.tilesize)
    self.enumstr = enumstr
		self.img = tile_img
    if enumstr == "wall" then
      coll:add(self, self.pos.x, self.pos.y, self.tilesize, self.tilesize)
    elseif enumstr == "err" then
      coll:add(self, self.pos.x, self.pos.y, self.tilesize, self.tilesize)
    end
	end
}

function Tile:draw()
	lg.draw(self.img, self.pos.x, self.pos.y)
end

Map = Class{
	init = function(self, w, h, tilemap)
		self.w = w
		self.h = h
		self.tilemap = tilemap
	end
}

function Map:draw()
	lg.setColor(1,1,1,1)
	for _, tileline in pairs(self.tilemap) do
    for _, tile in pairs(tileline) do
      tile:draw()
    end
	end
end

function map_utils.strls_to_map(w, h, strls_map)
  print("map width "..w..", height "..h)
	local tilemap = {}
	for y, tiles in pairs(strls_map) do
    local tileline = {}
		for x = 1, #tiles do
			local tilechar = tiles:sub(x,x)
      local curtile
			if tilechar == '-' or tilechar == 'B' or tilechar == 'S' or tilechar == 'P' then
        curtile = Tile(x, y, "floor", tileset.floor)
			elseif tilechar == "X" then
				curtile = Tile(x, y, "wall", tileset.wall)
      else
        curtile = Tile(x, y, "err", tileset.err)
			end
      table.insert(tileline, curtile)
      pixx = (x - 1) * TILESIZE
      pixy = (y - 1) * TILESIZE
      --if tilechar ~= '-' and tilechar ~= 'X' then
      --  print("Char: "..tilechar..", pos: ("..pixx..", "..pixy..")")
      --end
      if tilechar == 'P' then
        player = Player(pixx, pixy)
      elseif tilechar == 'B' then
        Brawler(pixx, pixy)
      elseif tilechar == 'S' then
        RifleShooter(pixx, pixy)
      end
		end
    table.insert(tilemap, tileline)
	end
	assert(w == string.len(strls_map[1]) and h == #strls_map, "Incoherent map_strls: "..w.."?="..string.len(strls_map[1]).."  "..h.."?="..#strls_map)
	map = Map(w, h, tilemap)
  return map
end

return map_utils
