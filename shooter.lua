RifleShooter = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 20, 50)
		self.cd = 3
	end,
	attack = function(self)
		local dx = player.x - self.x
		local dy = player.y - self.y
		local norm = math.sqrt(dx^2 + dy^2)
		local x = self.x + dx / norm * 23
		local y = self.y + dy / norm * 23
		Bullet(69, x, y, dx, dy)
	end,
	draw = function(self)
		lg.setColor(0,1,1,1)
		lg.rectangle("fill", self.x-8, self.y-8, 16, 16)
	end,
	update = function(self, dt)
		self.cd = self.cd - dt
		if self.cd <= 0 then
			self:attack()
			self.cd = 2 + self.cd
		end
	end
}

Projectile = Class{
	__includes = Entity,
	init = function(self, id, x, y, dx, dy, speed, damage)
		Entity.init(self, id, x, y, speed, 1)
		self.damage = damage
		self.dx = dx
		self.dy = dy
		self:normalize()
	end
}

Bullet = Class{
	__includes = Projectile,
	init = function(self, id, x, y, dx, dy)
		Projectile.init(self, id, x, y, dx, dy, 70, 20)
		--bullet sprite
	end,
	draw = function(self)
		lg.setColor(1,0,0,1)
		lg.circle("fill", self.x, self.y, 8)
	end
}
