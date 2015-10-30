
require("lib/lovebird").update()
newBall=require("ball")
newPlayer=require("player")
tac=require("lib.tactile")
camera=require("lib.hump.camera")
canvas = love.graphics.newCanvas(love.window.getWidth(), love.window.getHeight())
statuses={move=true,held=true}
input = {kick,quit,reset,nav={},cam={}}
players=0

function love.load(arg)
	cam=camera(400,300,.5,0,camera.smoothLinear,1000)
	love.joystick.loadGamepadMappings("assets/gamecontrollerdb.txt")

	ball=newBall(100,100,45,700)
	ball.img = love.graphics.newImage("assets/art/smallball.png")
	ball.width=ball.img:getWidth()
	ball.height=ball.img:getHeight()

	player=newPlayer(200,200)
	player.speed=200
	player.img=love.graphics.newImage("assets/art/left.png")


	love.graphics.setCanvas(canvas)
		canvas:clear()
		local curcol={love.graphics.getColor()}

		love.graphics.setColor(0,214,0)
		love.graphics.rectangle('fill',0,0,love.window.getWidth(),love.window.getHeight())

		love.graphics.setColor(curcol)
	love.graphics.setCanvas()
--framerate set
	min_dt = 1/60
	next_time = love.timer.getTime()

	input.quit=tac.newButton()
	input.quit:addDetector(tac.key('escape'))

	input.kick=tac.newButton()
	input.kick:addDetector(tac.key(' '))

	input.reset=tac.newButton()
	input.reset:addDetector(tac.key('r'))


	input.nav.up=tac.newButton()
	input.nav.up:addDetector(tac.key('up'))
	input.nav.up:addDetector(tac.gamepadButton('dpup',1))
	input.nav.up:addDetector(tac.thresholdButton(tac.analogStick('lefty', 1), -.5))

	input.nav.down=tac.newButton()
	input.nav.down:addDetector(tac.key('down'))
	input.nav.down:addDetector(tac.gamepadButton('dpdown',1))
	input.nav.down:addDetector(tac.thresholdButton(tac.analogStick('lefty', 1), .5))

	input.nav.left=tac.newButton()
	input.nav.left:addDetector(tac.key('left'))
	input.nav.left:addDetector(tac.gamepadButton('dpleft',1))
	input.nav.left:addDetector(tac.thresholdButton(tac.analogStick('leftx', 1), -.5))

	input.nav.right=tac.newButton()
	input.nav.right:addDetector(tac.key('right'))
	input.nav.right:addDetector(tac.gamepadButton('dpright',1))
	input.nav.right:addDetector(tac.thresholdButton(tac.analogStick('leftx', 1), .5))

	input.nav.select=tac.newButton()
	input.nav.select:addDetector(tac.key('x'))
	input.nav.select:addDetector(tac.gamepadButton('a',1))

	input.nav.back=tac.newButton()
	input.nav.back:addDetector(tac.key('z'))
	input.nav.back:addDetector(tac.gamepadButton('b',1))

	cam:lookAt(player.x+player.img:getWidth()/2,player.y-player.img:getHeight()/2)
	player:setupinput()


end
function updatekeys()
	input.quit:update()
	input.kick:update()
	input.reset:update()
	for i in ipairs(input.nav) do
		i:update()
	end
end
function love.update(dt)
	next_time = next_time + min_dt
	require("lib/lovebird").update()
	updatekeys()
	player:updatebuttons()

	if input.quit:pressed() then love.event.push('quit') end
    if input.kick:pressed() or player.kick:pressed() then ball:kick(700,300) end
	if input.reset:pressed() then ball:reset(100,100) end
	--cam:move(player.input.look.x:getValue()*20,player.input.look.y:getValue()*20)
	if ball.status.move then
		ball:edgeBounce()
		ball:move(dt)
	end
	player:move(dt)
	ball:friction(150,dt)
	cam:lockWindow(player.x+player.img:getWidth()/2,(player.y+player.img:getHeight()/2),player.x-20,player.x+20,player.y+20,player.y-20)
	--cam:lockPosition(player.x+player.img:getWidth()/2,player.y+player.img:getHeight()/2)
end

function love.draw(dt)
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
    	return
	end
	love.timer.sleep(next_time - cur_time)
	fps = love.timer.getFPS( )
	cam:attach()
	love.graphics.draw(canvas)
	love.graphics.polygon('line', 100, 100, 200, 100, 150, 200)
	love.graphics.draw(ball.img, ball.x, ball.y)
	love.graphics.draw(player.img, player.x, player.y)
	cam:detach()
	love.graphics.print(ball.speed)
	love.graphics.print(ball.angle,0,15)
	love.graphics.print(fps,0,30)
	love.graphics.print("("..ball.x..", "..ball.y..")", 0, 45)


end
