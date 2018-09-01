
local Vector = require "hump.vector"
require "collide"

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
    --self.hitbox_pos = Vector.new(x - 4, y - 12) 
    --self.hitbox_end = Vector.new(self.hitbox_pos.x + 16, self.hitbox_pos.y + 16)
    self.grid_pos = Vector.new(floor(self.x / 16), floor(self.y / 16))
		self:loadSprite()
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
		lg.draw(self.image, self.frames[self.currentFrame], self.x, self.y, 0, self.dir, 1, 12, 16)
		lg.setColor(0,1,0,1)
		lg.rectangle("line", coll:getRect(self))
	end,
  
	update = function(self, dt)
		self:setVel(dt)
		self.x, self.y = coll:move(self, self.x + self.dx - 8, self.y + self.dy, filter)
		self.x = self.x + 8
	end
}

function Player:loadSprite()
	local image  = lg.newImage("sprite.png")
	local width  = image:getWidth()
	local height = image:getHeight()
	local frameW = 24
	local frameH = 32
	local frames = {}

	for i=0,4 do
		table.insert(frames, lg.newQuad(1 + i*frameW + i, 1, frameW, frameH, width, height))
	end
	self.image = image
	self.frames = frames
	self.currentFrame = 1
	self.dir = 1
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
	--smoke thingy
end

function Player:setVel(dt)
	local p = self
	local up = isDown("w")
	local down = isDown("s")
	local left = isDown("a")
	local right = isDown("d") 

	p.dx = 0
	p.dy = 0
	if up then
		p.dy = -p.speed * dt
		p.currentFrame = 5
	end
	if down then
		p.dy = p.speed * dt
		p.currentFrame = 1
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
		p.currentFrame = 3
		if up then p.currentFrame = 4 end
		if down then p.currentFrame = 2 end
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
