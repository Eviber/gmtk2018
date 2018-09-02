require "collide"

Brawler = Class{
	__includes = Entity,
	init = function(self, x, y)
		Entity.init(self, "Brawler", x, y, 50, 50)
		self.origx = x - x % 16
		self.origy = y - x % 16
		self.damage = 20
		self.cooldown = 3
		self.attacking = false
		self.target = {x=x, y=y}
	end,
	draw = function(self)
		lg.setColor(1,0,1,1)
		lg.rectangle("fill", self.x, self.y, 16, 16)
		if self.attacking then
			lg.setColor(self.tBox.r, self.tBox.g, self.tBox.b, self.tBox.a)
			lg.	rectangle("fill", self.tBox.x + self.x, self.tBox.y + self.y, 16, 16)
		end
		--lg.setColor(0,1,0,1)
		--lg.rectangle("line", coll:getRect(self))
	end
}

function Brawler:update(dt)
	if self.health <= 0 then
		table.remove(EntitiesList, self.idx)
		coll:remove(self)
		return
	end
	self.cooldown = self.cooldown - dt
	playerDist = math.sqrt((self.x - player.x)^2 + (self.y - player.y)^2)
	if playerDist < 30 and not self.attacking and self.cooldown <= 0 then
		self.target.x = player.x
		self.target.y = player.y
		self.attacking = true
		self.cooldown = 2
		self:attack(dt)
	elseif self.attacking then
		self:attack(dt)
	elseif playerDist > 30 then
		local items, len = coll:querySegment(self.x + 8, self.y + 8, player.x, player.y, function(item) return not item.health end)
		if len == 0 then
			self.target.x = player.x
			self.target.y = player.y
		end
		local dx = self.target.x - self.x
		local dy = self.target.y - self.y
		if math.sqrt(dx^2+dy^2) < 64 then
			self.target.x = self.origx
			self.target.y = self.origy
		end
		self.dx = dx
		self.dy = dy
		self:normalize()
		self.x, self.y = coll:move(self, self.x + self.dx * dt, self.y + self.dy * dt, filter)
	end
end

function Brawler:attack(dt)
	if not self.tBox then
		self.tBox = {id="fist", lock=false, x=self.target.x-self.x, y=self.target.y-self.y, r=1, g=1, b=0, a=0.5}
	end
	if self.cooldown <= 0 then
		self.attacking = false
		self.tBox = nil
	elseif self.cooldown <= 0.5 then
		self.tBox.g = 0
		self.tBox.lock = true
		local items = coll:queryRect(self.tBox.x + self.x, self.tBox.y + self.y, 16, 16,
		function(item)
			if not item.health or item == self then
				return false
			end
			return "cross"
		end)
		for _, item in pairs(items) do
			if item:hit(self.damage) then
				local dx = item.x - self.x
				local dy = item.y - self.y
				local norm = math.sqrt(dx^2 + dy^2)
				local x = item.x + dx / norm * 100
				local y = item.y + dy / norm * 100
				item.x, item.y = coll:move(item, x, y, filter)
			end
		end
	end
end
