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
		if norm > self.speed then
			self.dx = dx / norm * self.speed
			self.dy = dy / norm * self.speed
		end
	end
	update = function(self, dt)
		if self.health <= 0 then
			print("Argh!")
		end
		self.x = self.dx * dt
		self.y = self.dy * dt
	end,
	draw = function(self)
		lg.setColor(1,1,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end
}

RifleShooter = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 20, 50)
	end,
	attack = function(self)
		Bullet:init(#table + 1, self.x, self.y, player.x - self.x, player.y - self.y)
	end,
	draw = function(self)
		lg.setColor(0,1,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end
}

Projectile = Class{
	__includes = Entity,
	init = function(self, id, x, y, dx, dy, speed, damage)
		Entity.init(self, id, x, y, speed, 1)
		self.damage = damage
		self.dx = dx
		self.dy = dy
		self.normalize()
	end
}

Bullet = Class{
	__includes = Projectile,
	init = function(self, id, x, y, dx, dy)
		Projectile.init(self, id, x, y, dx, dy, 70, 20)
		--bullet sprite
	end
	draw = function(self)
		lg.setColor(1,0,0,1)
		lg.circle("fill", self.x, self.y, 8)
	end
}

Brawler = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 50, 50)
		self.damage = 20
	end,
	attack = function(self)
		Bullet:init(#table + 1, self.x, self.y, player.x - self.x, player.y - self.y)
	end,
	draw = function(self)
		lg.setColor(1,0,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end
	--update = function(self, dt)
		
}

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
