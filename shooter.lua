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
		lg.rectangle("fill", self.x, self.y, 16, 16)
		--lg.setColor(0,1,0,1)
		--lg.rectangle("line", coll:getRect(self))
	end,
	update = function(self, dt)
		self.cd = self.cd - dt
		if self.cd <= 0 then
			self:attack()
			self.cd = 2 + self.cd
		end
		if self.health <= 0 then
			table.remove(EntitiesList, self.idx)
			coll:remove(self)
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
	end,
	update = function(self, dt)
		self.x, self.y, cols, len = coll:move(self, self.x + self.dx * dt, self.y + self.dy * dt, filter)
		if len > 0 then
			self.health = 0
      print(cols)
      print(cols[1])
      print(cols[1].other)
      if cols[1].other.health then
        cols[1].other.health = cols[1].other.health - self.damage
      end
		end
		if self.x < 0 or self.x > W or self.y < 0 or self.y > H then
			self.health = 0
		end
		if self.health <= 0 then
			table.remove(EntitiesList, self.idx)
			coll:remove(self)
		end
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
