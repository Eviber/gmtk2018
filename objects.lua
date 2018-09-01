Class = require "hump.class"
local lg = love.graphics

EntitiesList = {}

Entity = Class{
	init = function(self, id, x, y, speed, health)
		self.id = id
		self.x = x
		self.y = y
		self.dx = 0
		self.dy = 0
		self.speed = speed
		self.health = health
		table.insert(EntitiesList, self)
	end,
	destroy = function(self)
		table.remove(EntitiesList, self.id)
	end,
	normalize = function(self)
		local dx, dy = self.dx, self.dy
		local norm = math.sqrt(dx^2 + dy^2)
		self.dx = dx / norm * self.speed
		self.dy = dy / norm * self.speed
	end,
	update = function(self, dt)
		if self.health <= 0 then
			print("Argh!")
			table.remove(EntitiesList, self)
		end
		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	end,
	draw = function(self)
		lg.setColor(1,1,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end
}

require "shooter"

require "player"

Box = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 0, 20)
	end
}

Wall = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 0, 100)
	end
}
