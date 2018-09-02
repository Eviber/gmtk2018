Class = require "hump.class"
local lg = love.graphics
require "collide"

EntitiesList = {}

Entity = Class{
	init = function(self, id, x, y, speed, health)
		self.id = id
		self.idx = #EntitiesList + 1
		self.x = x
		self.y = y
		self.dx = 0
		self.dy = 0
		self.speed = speed
		self.health = health
		table.insert(EntitiesList, self)
		coll:add(self, x, y, 16, 16)
	end,
	destroy = function(self)
		table.remove(EntitiesList, self.id)
	end,
	normalize = function(self)
		local dx, dy = self.dx, self.dy
		local norm = math.sqrt(dx^2 + dy^2)
		if norm > 0 then
			self.dx = dx / norm * self.speed
			self.dy = dy / norm * self.speed
		end
	end,
	hit = function(self, damage)
		self.health = self.health - damage
		return true
	end,
	update = function(self, dt)
		if self.health <= 0 then
			print("Argh!")
			table.remove(EntitiesList, self)
			coll:remove(self)
		end
		self.x, self.y = coll:move(self, self.x + self.dx * dt, self.y + self.dy * dt, filter)
	end,
	draw = function(self)
		lg.setColor(1,1,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end
}

require "brawler"

require "shooter"

require "player"

Box = Class{
	__includes = Entity,
	init = function(self, x, y)
		Entity.init(self, "Box", x, y, 0, 20)
	end
}
