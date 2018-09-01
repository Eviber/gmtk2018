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
local db = require "debug"

map_utils = {}

tileset = {
	wall = lg.newImage("assets/tmp/tmp_wall.png"),
	floor = lg.newImage("assets/tmp/tmp_floor.png")
}

Tile = Class{
	tilesize = 16,
	init = function(self, x, y, tile_img)
		self.indices = Vector.new(x, y)
		self.pos = Vector.new((x - 1) * tilesize, (y - 1) * tilesize)
		self.img = tile_img
	end
}

function Tile:draw(canvas_data)
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
      tile.draw()
    end
	end
end

function map_utils.strls_to_map(w, h, strls_map)
	local tilemap = {}
	for y, tiles in pairs(strls_map) do
    local tileline = {}
		for x = 1, #tiles do
			tilechar = tiles[x]
			if tilechar == '-' then
				table.insert(tileline, Tile(x, y, tileset.floor))
			elseif tilechar == "X" then
				table.insert(tileline, Tile(x, y, tileset.wall))
			end
		end
    table.insert(tilemap, tileline)
	end
	assert(w == string.len(strls_map[1]) and h == #strls_map, "Incoherent map_strls: "..w.."?="..string.len(strls_map[1]).."  "..h.."?="..#strls_map)
	map = Map(w, h, tilemap)
	return map
end

return map_utils
