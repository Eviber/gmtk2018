lg = love.graphics
local isDown = love.keyboard.isDown

Player = Class{
	__includes = Entity,
	init = function(self, id, x, y, health, speed)
		Entity.init(self, id, x, y)
		self.health = health
		self.speed = speed
		self.dx = 0
		self.dy = 0
		self:loadSprite()
	end,
	swap = function(self, target)
		self.x = target.x
		self.y = target.y
		--smoke thingy
	end,
	reset = function(self)
		self.x = W/2
		self.y = H/2
		self.health = 100
		self.speed = 100
	end,
	draw = function(self)
		lg.draw(self.image, frames[self.currentFrame], self.x, self.y, 0, self.dir, 1, 12, 16)
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
	self.frame = frame
	self.currentFrame = 1
	self.dir = 1
end

function Player:move(dt)
	local p = self
	local up = isDown("up")
	local down = isDown("down")
	local left = isDown("left")
	local right = isDown("right") 

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
	p.x = p.x + p.dx
	p.y = p.y + p.dy
end
