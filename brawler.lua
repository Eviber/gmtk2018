require "collide"

Brawler = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		Entity.init(self, id, x, y, 50, 50)
		self.damage = 20
		self.cooldown = 3
	end,
	attack = function(self)
		Bullet(69, self.x, self.y, player.x - self.x, player.y - self.y)
	end,
	draw = function(self)
		lg.setColor(1,0,1,1)
		lg.rectangle("fill", self.x, self.y, 16, 16)
		--lg.setColor(0,1,0,1)
		--lg.rectangle("line", coll:getRect(self))
	end,
	update = function(self, dt)
		if self.health <= 0 then
			table.remove(EntitiesList, self.idx)
			coll:remove(self)
			return
		end
		self.cooldown = self.cooldown - dt
		playerDist = math.sqrt((self.x - player.x)^2 + (self.y - player.y)^2)
		if playerDist < 30 and self.cooldown <= 0 then
			self:attack()
			self.cooldown = 2
		elseif playerDist > 30 then
			self.dx = player.x - self.x
			self.dy = player.y - self.y
			self:normalize()
			self.x, self.y = coll:move(self, self.x + self.dx * dt, self.y + self.dy * dt, filter)
		end
	end
}
