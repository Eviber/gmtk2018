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

local Vector = require "hump.vector"
local Class = require "hump.class"
local lg = love.graphics
local debug = require "debug"

map_utils = {}

tileset = {
	wall = lg.newImage("assets/tmp/tmp_wall.png"),
	floor = lg.newImage("assets/tmp/tmp_floor.png"),
  error = lg.newImage("assets/tmp/tmp_error.png")
}

Tile = Class{
	tilesize = 16,
	init = function(self, x, y, enumstr, tile_img)
		self.indices = Vector.new(x, y)
		self.pos = Vector.new((x - 1) * self.tilesize, (y - 1) * self.tilesize)
    self.enumstr = enumstr
		self.img = tile_img
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
			if tilechar == '-' then
        curtile = Tile(x, y, "floor", tileset.floor)
			elseif tilechar == "X" then
				curtile = Tile(x, y, "wall", tileset.wall)
      else
        curtile = Tile(-1, -1, "error", tileset.error)
			end
      table.insert(tileline, curtile)
		end
    table.insert(tilemap, tileline)
	end
	assert(w == string.len(strls_map[1]) and h == #strls_map, "Incoherent map_strls: "..w.."?="..string.len(strls_map[1]).."  "..h.."?="..#strls_map)
	map = Map(w, h, tilemap)
  return map
end

return map_utils
