Class = require "hump.class"
local lg = love.graphics

EntitiesList = {}

Entity = Class{
	init = function(self, id, x, y)
		self.id = id
		self.x = x
		self.y = y
		table.insert(EntitiesList, id)
	end,
	destroy = function(self)
		table.remove(EntitiesList, self.id)
	end
}

Enemy = Class{
	__includes = Entity,
	init = function(self, id, x, y, move, health)
		Entity.init(self, id, x, y)
		self.move = move
		self.health = health
	end
}

RifleShooter = Class{
	__includes = Enemy,
	init = function(self, id, x, y)
		Enemy.init(self, id, x, y, 3, 10)
	end,
	attack = function(x, y)
		Bullet:init(table.getn(EntitiesList), x, y, 6, 10)
	end
}

Projectile = Class{
	__includes = Entity,
	init = function(self, id, x, y, velocity, damage)
		Entity.init(self, id, x, y)
		self.velocity = velocity
		self.damage = damage
	end
}

Bullet = Class{
	__includes = Projectile,
	init = function(self, id, x, y, velocity, damage)
		Projectile.init(self, id, x, y, velocity, damage)
		--bullet sprite
	end
}

require "player"

Box = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y)
	end
}

Wall = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y)
	end
}
