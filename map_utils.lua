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

map_utils = {}

W = 800
H = 600

love.window.setMode(W, H, {resizable = false})

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
		self.tiles = tilemap
	end
}

function Map:draw()
	for tile in self.tiles do
		tile.draw()
	end
end

function map_utils.strls_to_map(w, h, strls_map)
	local tilemap = {}
	for y, tiles in pairs(strls_map) do
		for x = 1, #tiles do
			tile = tiles[x]
			if tile == '-' then
				table.insert(tilemap, Tile.init(x, y, tileset.floor))
			elseif tile == "X" then
				table.insert(tilemap, Tile.init(x, y, tileset.wall))
			end
		end
	end
	assert(w == string.len(strls_map[1]) and h == #strls_map, "Incoherent map_strls: "..w.."?="..string.len(strls_map[1]).."  "..h.."?="..#strls_map)
	map = Map:init(w, h, tilemap)
	return map
end

return map_utils
