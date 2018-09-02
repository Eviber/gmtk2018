
local Vector = require "hump.vector"
require "collide"
local peachy = require "peachy.peachy"

lg = love.graphics
local isDown = love.keyboard.isDown
local floor = math.floor

Player = Class{
	__includes = Entity,
	init = function(self, id, x, y)
		x = x or W/2
		y = y or H/2
		Entity.init(self, id, x, y)
		self.health = 100
		self.speed = 100
		self.dx = 0
		self.dy = 0
    self.swapping = false
    self.swap_fx = false
    self.swap_target = nil
    --self.hitbox_pos = Vector.new(x - 4, y - 12) 
    --self.hitbox_end = Vector.new(self.hitbox_pos.x + 16, self.hitbox_pos.y + 16)
    self.grid_pos = Vector.new(floor(self.x / 16), floor(self.y / 16))
    self.sprite = peachy.new("assets/player.json", love.graphics.newImage("assets/player.png"), "walk_D")
    self.angle = 1
    self.dir = 1
		coll:update(self, x, y)
	end,
  
	reset = function(self)
		self.x = W/2
		self.y = H/2
		self.health = 100
		self.speed = 100
	end,
  
	draw = function(self)
		lg.setColor(1,1,1,1)
		self.sprite:draw(self.x, self.y, 0, self.dir, 1, 12, 16)
		lg.setColor(0,1,0,1)
		lg.rectangle("line", coll:getRect(self))
	end,
  
	update = function(self, dt)
		if not self.swapping then
      self:setVel(dt)
      self.x, self.y = coll:move(self, self.x + self.dx - 8, self.y + self.dy, filter)
      self.x = self.x + 8
    end
    self.sprite:update(dt)
	end
}

function Player:swap_prepare(target)
  self.swap_target = target
  self.swapping = true
  if self.angle == 0 then print("error")
  elseif self.angle == 1 then self.sprite:setTag("swap_D")
  elseif self.angle == 2 then self.sprite:setTag("swap_DR")
  elseif self.angle == 3 then self.sprite:setTag("swap_R")
  elseif self.angle == 4 then self.sprite:setTag("swap_UR")
  elseif self.angle == 5 then self.sprite:setTag("swap_U")
  end
end
function Player:swap(target)
	local x = self.x
	local y = self.y

	self.x = target.x
	self.y = target.y
	coll:update(self, self.x, self.y)
	target.x = x
	target.y = y
	coll:update(target, x, y)
  self.swap_fx = true
end

function Player:setVel(dt)
	local p = self
	local up = isDown("w") or isDown("z")
	local down = isDown("s")
	local left = isDown("a") or isDown("q")
	local right = isDown("d") 

	p.dx = 0
	p.dy = 0
	if up then
		p.dy = -p.speed * dt
    self.sprite:setTag("walk_U")
    self.angle = 5
	end
  if down then
		p.dy = p.speed * dt
    self.sprite:setTag("walk_D")
    self.angle = 1
	end
  if left then
		p.dx = -p.speed * dt
		p.dir = -1
	end
  if right then
		p.dx = p.speed * dt
		p.dir = 1
	end
  if left or right then
    self.sprite:setTag("walk_R")
    self.angle = 3
		if up then
      self.sprite:setTag("walk_UR")
      self.angle = 4
    end
		if down then
      self.sprite:setTag("walk_DR")
      self.angle = 2
    end
  end
  if (up or down or left or right) then
    self.sprite:play()
  else
    self.sprite:pause()
	end
	do
		local dx, dy = p.dx, p.dy
		local norm = math.sqrt(dx^2 + dy^2)
		local max = p.speed * dt
		if norm > max then
			p.dx = dx / norm * max
			p.dy = dy / norm * max
		end
	end
end
