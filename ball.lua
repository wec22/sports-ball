local ball = {status={move=true,held=false}}
ball.__index=ball

function ball.new(x,y,angle,speed)
    local self={}
    if not love.load then error("Ball instance must be created inside love.load") end
    self.x=x
    self.y=y
    self.angle=angle
    self.speed=speed

    return setmetatable(self, ball)
end

function ball:move(dt)
	if self.status.move then
        self.x=self.x+(self.speed*dt*math.cos(math.rad(self.angle)))
	    self.y=self.y-(self.speed*dt*math.sin(math.rad(self.angle)))
    end


end

function ball:edgeBounce()
    if self.x<=0 then
        self.angle=180-self.angle
		if self.angle<0 then self.angle=self.angle+360 end
        self:errcheck()
        return true
	elseif self.y<=0 then
        self.angle=self.angle*-1
		if self.angle<0 then self.angle=self.angle+360 end
        self:errcheck()
		return true
    elseif self.x+self.img:getWidth()>=love.window.getWidth() then
        self.angle=180-self.angle
		if self.angle<0 then self.angle=self.angle+360 end
        self:errcheck()
        return true
	elseif self.y+self.img:getHeight()>=love.window.getHeight() then
        self.angle=self.angle*-1
		if self.angle<0 then self.angle=self.angle+360 end
        self:errcheck()
        return true
    else
        return false
    end
end

function ball:errcheck()
    if self.y<0 then self.y=0
    elseif self.x<0 then self.x=0
    elseif self.x+self.img:getWidth()>love.window.getWidth() then self.x=love.window.getWidth()-self.img:getWidth()
    elseif self.y+self.img:getHeight()>love.window.getHeight() then self.y=love.window.getHeight()-self.img:getHeight() end
end

function ball:friction(amount,dt)
    self.speed=self.speed-amount*dt
    if self.speed<=0 then
        self.speed=0
        self.status.move=false
    end
end

function ball:kick(force,threshhold)
    if self.speed<=threshhold then
        self.speed=self.speed+force
        self.status.move=true
    end
end

function ball:reset(x,y)
    self.x=x
    self.y=y
end

return setmetatable({new = new}, {__call = function(_, ...) return ball.new(...) end})
