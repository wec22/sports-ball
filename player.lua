--tac=require("tactile")
local player={}
player.__index=player

function player.new(x,y)
    local self={}
    self.x=x
    self.y=y
    self.input={move={},look={}}

    players=players+1
    self.num=players
    return setmetatable(self, player)
end

function player:move(dt)
    self.x=self.x+(self.speed*dt*self.input.move.x:getValue())
    self.y=self.y+(self.speed*dt*self.input.move.y:getValue())
end

function player:setupinput(keys)
    self.input.move.x=tac.newAxis()
	self.input.move.x:addDetector(tac.analogStick('leftx', self.num))
	self.input.move.x.deadzone=1/8

	self.input.move.y=tac.newAxis()
	self.input.move.y:addDetector(tac.analogStick('lefty', self.num))
	self.input.move.y.deadzone=1/8

	self.input.look.x=tac.newAxis()
	self.input.look.x:addDetector(tac.analogStick('rightx', self.num))
	self.input.look.x.deadzone=1/8

	self.input.look.y=tac.newAxis()
	self.input.look.y:addDetector(tac.analogStick('righty', self.num))
	self.input.look.y.deadzone=1/8

    input.quit:addDetector(tac.gamepadButton('guide',self.num))
    self.kick=tac.newButton(tac.gamepadButton('a',self.num))
    input.reset:addDetector(tac.gamepadButton('back',self.num))

    if love.joystick.getJoystickCount()<=self.num then
        self.input.move.x:addDetector(tac.binaryAxis(tac.key('left'),tac.key('right')))
        self.input.move.y:addDetector(tac.binaryAxis(tac.key('up'),tac.key('down')))
        self.input.look.x:addDetector(tac.binaryAxis(tac.key('left'),tac.key('right')))
        self.input.look.y:addDetector(tac.binaryAxis(tac.key('up'),tac.key('down')))
    end

end

function player:updatebuttons()
    self.kick:update()

end







return setmetatable({new = new}, {__call = function(_, ...) return player.new(...) end})
