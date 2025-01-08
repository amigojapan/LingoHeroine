
local composer = require( "composer" )


local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
debugVersion="              alpha1"
gridSize=64
moveSpeed = gridSize
timeForMoveInMilliseconds=500
lifePerecentage=100
lifeX=gridSize*11.5
lifeY=gridSize*1.6
lifeW=gridSize*3
lifeH=gridSize/2
fireRatTimer=nil
slots = {}
speed = composer.getVariable( "speed" )
if speed=="2" then
	speed=2
else
	speed=1
end

for i = 2, 14 do
    slots[i] = {}

    for j = 2, 10 do
        slots[i][j] = "empty slot" -- Fill the values here
    end
end

tom = display.newGroup()
tom.x=10
tom.y=10
repeat
	x=math.random(2,14)
	y=math.random(2,10)
until( slots[x][y]=="empty slot" )
slots[tom.x][tom.y]="tom"

-- Define grid boundaries
local gridWidth = display.contentWidth
local gridHeight = display.contentHeight
--tom.InMotion=false
kitchen={}
function redo(val1,x,y)
	if (val1.x==x and val1.y==y) or (val1.x==tom.x and val1.y==tom.y) then
		--scrap old stuff cause they overlap
		x=math.random(2,14)
		y=math.random(2,10)	
		return redo(val1,x,y)
	else
		return	x,y
	end				
end
function generateRandomBush()
	repeat
		x=math.random(2,14)
		y=math.random(2,10)
	until( slots[x][y]=="empty slot" )
	slots[x][y]="bush"
	obj=display.newImage("img/bush.png", x*gridSize, y*gridSize, gridSize, gridSize)
	obj.myName="bush"
	table.insert(kitchen, obj)
end
powerups={}
function generateRandomPowerUp()
	x=math.random(2,14)
	y=math.random(2,10)
	repeat
		x=math.random(2,14)
		y=math.random(2,10)
	until( slots[x][y]=="empty slot" )
	slots[x][y]="star"
	sprite=display.newImage("img/power-up.png", x*gridSize, y*gridSize, gridSize, gridSize)
	obj.myName="star"
	table.insert(powerups, sprite)
end
enemies={}
function generateRandomSlime()
	x=math.random(2,14)
	y=math.random(2,10)
	repeat
		x=math.random(2,14)
		y=math.random(2,10)
	until( slots[x][y]=="empty slot" )
	slots[x][y]="slime"
	local slime = display.newGroup()
	color=math.random(1,3)
	if color==1 then
		slime.facingDownImg=display.newImage(slime, "img/purpleSlimeFacingFoward.png")
		slime.facingUpImg=display.newImage(slime, "img/purpleSlimeFacingBackword.png")
		slime.facingLeftImg=display.newImage(slime, "img/purpleSlimeFacingLeft.png")
		slime.facingRightImg=display.newImage(slime, "img/purpleSlimeFacingRight.png")
	elseif color==2 then
		slime.facingDownImg=display.newImage(slime, "img/greenSlimeFacingFoward.png")
		slime.facingUpImg=display.newImage(slime, "img/greenSlimeFacingBackword.png")
		slime.facingLeftImg=display.newImage(slime, "img/greenSlimeFacingLeft.png")
		slime.facingRightImg=display.newImage(slime, "img/greenSlimeFacingRight.png")
	elseif color==3 then --hacking the ghost as the third color of slime
		slime.facingDownImg=display.newImage(slime, "img/ghostFacingFoward.png")
		slime.facingUpImg=display.newImage(slime, "img/ghostFacingBackword.png")
		slime.facingLeftImg=display.newImage(slime, "img/ghostFacingLeft.png")
		slime.facingRightImg=display.newImage(slime, "img/ghostFacingRight.png")
	end
	slime.myName="slime"
	slime.x=x*gridSize
	slime.y=y*gridSize
	table.insert(enemies, slime)
end

function updateLifeBar()
	if gameover or dailyScoresScreen then
		return
	end
	lifeBarBlueRectangle.width = lifeW * (lifePerecentage / 100)
end
restartGameTimer=nil
function restartGame()
	timer.cancel(restartGameTimer)
	hideEverything()
	audio.play(gameOverSoundEffect)
	composer.gotoScene( "GameOver" )
end

function checkForStangeClear()
	local enemyCount=0
	for key, enemy in ipairs(enemies) do
		if enemy.isVisible then
			enemyCount=enemyCount+1
		end
	end
	if enemyCount == 0 then
		print("paczel Stage Clear")
		if fireRatTimer ~= nil then
			timer.cancel(fireRatTimer)--(not fixed)trying to stop the monsters from flipping twice after second round
		end	
		hideEverything()
		gameover=true
		composer.removeScene("game")
		composer.gotoScene("StageClear")
	end
end
function gameOver()
	lifePerecentage=0
	updateLifeBar()
	--Runtime:removeEventListener( "enterFrame", enterFrame)
	print("paczel Game Over")
	--hideEverything()
	gameover=true
	clearAllWitchSprites()
	if tom.direction=="left" then
		print("collapsed1")
		tomFacingLeftCollapsedImg.isVisible=true
	elseif tom.direction=="right" then
		print("collapsed2")
		tomFacingRightCollapsedImg.isVisible=true
	elseif tom.direction=="up" then
		print("collapsed3")
		tomFacingUpCollapsedImg.isVisible=true
	elseif tom.direction=="down" then
		print("collapsed4")
		tomFacingDownCollapsedImg.isVisible=true
	else
		print("collapsed5")
		tomFacingDownCollapsedImg.isVisible=true
	end
	clearAllWitchSprites()
	restartGameTimer = timer.performWithDelay( 3000*speed, restartGame, 0 )
	if fireRatTimer then
		timer.cancel(fireRatTimer)--(not fixed)trying to stop the monsters from flipping twice after second round
	end
	--hideOrder()
	--hideOrderSlip()
	--hideEverythingHacky()
	--require("writeScores")
	--local totalPointsFinal = composer.getVariable( "totalPointsFinal" )
	--if totalPointsFinal==nil then
	--	totalPointsFinal=0
	--end
	--writeScore("\n"..tostring(totalPointsFinal), difficulty)
	--composer.setVariable( "totalPointsFinal", nil )
	--sentScores()
	--composer.setVariable( "gameIsOver", true )
	--print("goto menu")
	composer.removeScene("game")
	--composer.removeScene( "menu" )
	--composer.gotoScene( "dailyScoresScreen" )
end
function handleRatCollision(sprite)
	if sprite.isVisible==false then
		return
	end
	if gameover then
		return
	end
	print("called rat collision handler")
	lifePerecentage=lifePerecentage-5
	updateLifeBar()
	if lifePerecentage <= 11 then
		gameOver()
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

end

gamePaused=false
function  gamePauseAndResumeFunction()
	if gamePaused==false then
		pauseButton.text="[START]"
		gamePaused=true			
	else
		pauseButton.text="[PAUSE]"
		gamePaused=false 
	end	
end
pauseButton=nil
function  endDayFunction()
	gameOver()
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--draw tiled backgouod
		for x = 1, 	15
		do
			for y = 1, 11 
			do
				local myRectangle = display.newRect(x*gridSize, y*gridSize, gridSize, gridSize )
				myRectangle.strokeWidth = 0
				myRectangle:setFillColor( 0.588 , 0.294 , 0 )--brown
				myRectangle:setStrokeColor( 0, 0, 0 )
				sceneGroup:insert(myRectangle) 
			end
		end

		background = display.newGroup()

		x=1
		for y = 1, 11 
		do
			obj=display.newImage(background,"img/bush.png", x*gridSize, y*gridSize, gridSize, gridSize)
			obj.myName="bush"
			table.insert(kitchen, obj)
		end
		x=15
		for y = 1, 11 
		do
			obj=display.newImage(background,"img/bush.png", x*gridSize, y*gridSize, gridSize, gridSize)
			obj.myName="bush"
			table.insert(kitchen, obj)
		end

		y=1
		for x = 1, 	15
		do
			obj=display.newImage(background,"img/bush.png", x*gridSize, y*gridSize, gridSize, gridSize)
			obj.myName="bush"
			table.insert(kitchen, obj)
		end
		y=11
		for x = 1, 	15
		do
			obj=display.newImage(background,"img/bush.png", x*gridSize, y*gridSize, gridSize, gridSize)
			obj.myName="bush"
			table.insert(kitchen, obj)
		end


		for counter=1,7 do
			generateRandomBush()
		end
		x=2
		y=2
		numberOfPowerUps = composer.getVariable( "numberOfPowerUps" )
		for counter=1,numberOfPowerUps do
			generateRandomPowerUp()
		end
		numberOfMonsters = tonumber(composer.getVariable( "numberOfMonsters" ))
		for counter=1,numberOfMonsters do
			generateRandomSlime()
		end

		tomImg = display.newImageRect(tom, "img/mageFacingForward.png", gridSize, gridSize)
		tomFacingForwardWalk1Img = display.newImageRect(tom, "img/mageFacingForwardWalk1.png", gridSize, gridSize)
		tomFacingForwardWalk2Img = display.newImageRect(tom, "img/mageFacingForwardWalk2.png", gridSize, gridSize)
		tomFacingForwardWalk1Img.isVisible=false
		tomFacingForwardWalk2Img.isVisible=false

		tomFacingBackwardWalk1Img = display.newImageRect(tom, "img/mageFacingbackwardWalk1.png", gridSize, gridSize)
		tomFacingBackwardWalk2Img = display.newImageRect(tom, "img/mageFacingbackwardWalk2.png", gridSize, gridSize)
		tomFacingBackwardWalk1Img.isVisible=false
		tomFacingBackwardWalk2Img.isVisible=false

		tomFacingRightWalk1Img = display.newImageRect(tom, "img/mageFacingRightWalk1.png", gridSize, gridSize)
		tomFacingRightWalk2Img = display.newImageRect(tom, "img/mageFacingRightWalk2.png", gridSize, gridSize)
		tomFacingRightWalk1Img.isVisible=false
		tomFacingRightWalk2Img.isVisible=false

		tomFacingLeftWalk1Img = display.newImageRect(tom, "img/mageFacingLeftWalk1.png", gridSize, gridSize)
		tomFacingLeftWalk2Img = display.newImageRect(tom, "img/mageFacingLefttWalk2.png", gridSize, gridSize)
		tomFacingLeftWalk1Img.isVisible=false
		tomFacingLeftWalk2Img.isVisible=false



		tomFacingUpCollapsedImg = display.newImageRect(tom, "img/mageFacingRightCollapsed.png", gridSize, gridSize)
		tomFacingRightCollapsedImg = display.newImageRect(tom, "img/mageFacingRightCollapsed.png", gridSize, gridSize)
		tomFacingUpCollapsedImg.isVisible=false
		tomFacingRightCollapsedImg.isVisible=false
		tomFacingDownCollapsedImg = display.newImageRect(tom, "img/mageFacingLeftCollapsed.png", gridSize, gridSize)
		tomFacingLeftCollapsedImg = display.newImageRect(tom, "img/mageFacingLeftCollapsed.png", gridSize, gridSize)
		tomFacingLeftCollapsedImg.isVisible=false
		tomFacingDownCollapsedImg.isVisible=false



		lifeBarRedRectangle = display.newRect(lifeX, lifeY, lifeW, lifeH)
		lifeBarRedRectangle:setFillColor(1,0,0)
		lifeBarBlueRectangle = display.newRect(lifeX, lifeY, lifeW, lifeH)
		lifeBarBlueRectangle:setFillColor(0,0,1)
		lifeBarBlueRectangle.anchorX=0
		lifeBarRedRectangle.anchorX=0
		lifeBarBlueRectangle.alpha=1
		lifeBarRedRectangle.alpha=1

		tom.x=gridSize*tom.x
		tom.y=gridSize*tom.y
		tom.myName="tom"

		col = display.newText( "collision:false",  gridSize*2, gridSize*2, "fonts/ume-tgc5.ttf", 40 )

		endDay = display.newText( sceneGroup, "[QUIT]", 100, 15, "fonts/ume-tgc5.ttf", 44 )
		endDay:setFillColor( 0.82, 0.86, 1 )
		endDay:addEventListener( "tap", endDayFunction )

		pauseButton = display.newText( sceneGroup, "[PAUSE]", 300, 15, "fonts/ume-tgc5.ttf", 44 )
		pauseButton:setFillColor( 0.82, 0.86, 1 )
		pauseButton:addEventListener( "tap", gamePauseAndResumeFunction )

		gameover=false

		
	end
end

function hideEverything()
	--for key, bush in ipairs() do
	--	bush.isVisible=false
	--end
	for key, enemy in ipairs(enemies) do
		--clearAllEnemySprites(enemy)
		enemy.isVisible=false
	end
	for key, star in ipairs(powerups) do
		star.isVisible=false
	end
	for key, obj in ipairs(kitchen) do
		obj.isVisible=false
	end
	tom.isVisible=false
	tomFacingDownCollapsedImg.isVisible=false
	tomFacingUpCollapsedImg.isVisible=false
	tomFacingLeftCollapsedImg.isVisible=false
	tomFacingRightCollapsedImg.isVisible=false
	lifeBarBlueRectangle.isVisible=false
	lifeBarRedRectangle.isVisible=false
	myUpButton.isVisible=false
	myDownButton.isVisible=false
	myLeftButton.isVisible=false
	myRightButton.isVisible=false
	myFireButton.isVisible=false
	col.isVisible=false
	--stop music
	audio.stop( 1 )
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)


	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
function clearAllWitchSprites()
	tomImg.isVisible=false
	tomFacingForwardWalk1Img.isVisible=false
	tomFacingForwardWalk2Img.isVisible=false

	tomFacingBackwardWalk1Img.isVisible=false
	tomFacingBackwardWalk2Img.isVisible=false

	tomFacingLeftWalk1Img.isVisible=false
	tomFacingLeftWalk2Img.isVisible=false

	tomFacingRightWalk1Img.isVisible=false
	tomFacingRightWalk2Img.isVisible=false
end

function clearAllEnemySprites(enemy)
		enemy.facingDownImg.isVisible=false
		enemy.facingUpImg.isVisible=false
		enemy.facingLeftImg.isVisible=false
		enemy.facingRightImg.isVisible=false
end


function onCompletecallback(obj)
	if gameover then
		return
	end
	obj.InMotion=false
	if obj.myName=="tom" then
		print("object is tom, tom.direction:"..tom.direction)
		if obj.direction=="down" then
			if tomFacingForwardWalk1Img.isVisible==true then
				clearAllWitchSprites()
				tomFacingForwardWalk2Img.isVisible=true
			else
				clearAllWitchSprites()
				tomFacingForwardWalk1Img.isVisible=true
			end
		end
		if obj.direction=="up" then
			if tomFacingBackwardWalk1Img.isVisible==true then
				clearAllWitchSprites()
				tomFacingBackwardWalk2Img.isVisible=true
			else
				clearAllWitchSprites()
				tomFacingBackwardWalk1Img.isVisible=true
			end
		end
		if obj.direction=="left" then
			if tomFacingLeftWalk1Img.isVisible==true then
				clearAllWitchSprites()
				tomFacingLeftWalk2Img.isVisible=true
			else
				clearAllWitchSprites()
				tomFacingLeftWalk1Img.isVisible=true
			end
		end
		if obj.direction=="right" then
			if tomFacingRightWalk1Img.isVisible==true then
				clearAllWitchSprites()
				tomFacingRightWalk2Img.isVisible=true
			else
				clearAllWitchSprites()
				tomFacingRightWalk1Img.isVisible=true
			end
		end
	end
end
numberOfFireballs=0
fireBall=nil
changeDirection=false
function moveInDirection(dx, dy, direction, movingObject)
	if gamePaused or gameover or dailyScoresScreen then
		return
	end
	if movingObject.myName == "slime" then
		if detectCollision2(movingObject,tom) then
			print("collided with slime")
			handleRatCollision(movingObject)
		end
	end
	if movingObject.myName == "tom" then
		--happens when tom moves
		--print(tostring(movingObject.InMotion))
		for key, sprite in ipairs(powerups) do
			if detectCollision2(movingObject,sprite) then
				--print("fireball collided with:"..sprite.myName)
				--if sprite.myName == "slime" then
					-- happens when slime collided with fireball
					if sprite.isVisible then
						numberOfFireballs=numberOfFireballs+1	
						audio.play(getStarSoundEffect)
						sprite.isVisible=false
					end

					
				--end
			end
		end	
	end
	if movingObject.myName == "slime" then
		if detectCollision2(tom,movingObject) then
			handleRatCollision(movingObject)
		end
	end
	if movingObject.InMotion then
		return
	end
	
		
	-- Calculate new position
	local newX = movingObject.x + dx
	local newY = movingObject.y + dy

	
	-- Check boundaries
		if newX - (movingObject.width / 2) < 0 or newX + (movingObject.width / 2) > gridWidth or newY - (movingObject.height / 2) < 0 or newY + (movingObject.height / 2) > gridHeight then
			return
		end

	movingObject.InMotion = true
	movingObject:translate(dx, dy)
	local collided=false
	if fireBall then
		--print("fireBall.x:"..fireBall.x.." fireBall.y:"..fireBall.y)
		for key, sprite in ipairs(enemies) do
			if detectCollision2(fireBall,sprite) then
				--print("fireball collided with:"..sprite.myName)
				--if sprite.myName == "slime" then
					-- happens when slime collided with fireball
					if fireBall.isVisible==true then --this is to prevent collision when freezeball, we are sharing the same object name as fireball
						sprite.isVisible=false
						audio.play(mosterDeadSoundEffect)
						checkForStangeClear()
					end
				--end
			end
			if detectCollision2(tom,sprite) then
				handleRatCollision(sprite)
			end
			
		end
	end


    for key, sprite in pairs(kitchen) do
        if detectCollision(
                movingObject.x - (movingObject.width / 2),
                movingObject.y - (movingObject.height / 2), 
                movingObject.width, movingObject.height,
                sprite.x - (sprite.width / 2),
                sprite.y - (sprite.height / 2),
                sprite.width, 
				sprite.height
            ) then
            if movingObject.myName == "tom" then
                -- happens when tom moves
				print("collision detected with tom")
				--collided=ture
                col.text = debugVersion .. "collision:true kitchen object:"..sprite.myName
                --handleKitchenCollision(sprite)
				if ((tom.holdingBroom  and  sprite.myName=="broom") or sprite.myName=="Fridge Door Fries" or sprite.myName=="Fridge Door Patties" or sprite.myName=="Fridge Door Close" or sprite.myName=="hide orders slip box") then
					--make kitchen object non solid
					collided=false
					break	
				end
            end
			collided = true
		else
			--fridgeDoorPatties.isVisible=false
        end
    end


	--d=nil

    if collided then
        movingObject.InMotion = false
    end

	movingObject:translate(-dx, -dy)
	-- If no collision, move movingObject to the new position
	numberOfSteps=1
	if movingObject.myName=="tom" then
		movingObject.direction=direction
	end
	if movingObject.myName=="slime" then
		--print("slime move:"..direction)
		movingObject.direction=direction
	end
	
	if direction == "left" and not collided then
		transition.to(movingObject, {time = timeForMoveInMilliseconds/numberOfSteps, x = movingObject.x - (gridSize/numberOfSteps), onComplete = onCompletecallback})
	elseif direction == "right" and not collided then
		transition.to(movingObject, {time = timeForMoveInMilliseconds/numberOfSteps, x = movingObject.x + (gridSize/numberOfSteps), onComplete = onCompletecallback})
	elseif direction == "up" and not collided then
		transition.to(movingObject, {time = timeForMoveInMilliseconds/numberOfSteps, y = movingObject.y - (gridSize/numberOfSteps), onComplete = onCompletecallback})
	elseif direction == "down" and not collided then
		transition.to(movingObject, {time = timeForMoveInMilliseconds/numberOfSteps, y = movingObject.y + (gridSize/numberOfSteps), onComplete = onCompletecallback})	
	end	
	collided=false
end


function moveTomLeft()
	if gamePaused or gameover then
		return
	end
	if tom.direction~="left" then
		--print("direction switched to left")
		clearAllWitchSprites()
		tomFacingLeftWalk1Img.isVisible=true			
	end
	moveInDirection( -moveSpeed, 0 , "left", tom )
end

function moveTomRight()
	if gamePaused or gameover then
		return
	end
	if tom.direction~="right" then
		print("direction switched to right")
		clearAllWitchSprites()
		tomFacingRightWalk1Img.isVisible=true			
	end
	moveInDirection( moveSpeed, 0, "right", tom )
end

function moveTomUp()
	if gamePaused or gameover then
		return
	end
	if tom.direction~="up" then
		print("direction switched to up")
		clearAllWitchSprites()
		tomFacingBackwardWalk1Img.isVisible=true			
	end
	moveInDirection( 0, -moveSpeed, "up", tom )
end

function moveTomDown()
	if gamePaused or gameover then
		return
	end
	if tom.direction~="down" then
		print("direction switched to down")
		clearAllWitchSprites()
		tomFacingForwardWalk1Img.isVisible=true			
	end
	moveInDirection( 0, moveSpeed, "down", tom )
end


function onCompletecallbackFireball()

end
function onCompletecallbackFrezeball(obj)
	obj.isVisible=false
end

function fireball()
	print("fireball count:"..numberOfFireballs)
	if numberOfFireballs>0 then
		if tom.direction=="up" then
			print("up fireball")
			fireBall=display.newImage("img/tmp-fireball.png", tom.x, tom.y-gridSize, gridSize, gridSize)
			fireBall.isVisible=true
			fireBall.width=gridSize*3
			fireBall.height=gridSize*3
			audio.play(fireSoundEffect)
			transition.to(fireBall, {time = timeForMoveInMilliseconds+5000, y = -500, onComplete = onCompletecallbackFireball})
		end
		if tom.direction=="left" then
			print("up fireball")
			fireBall=display.newImage("img/tmp-fireball.png", tom.x-gridSize, tom.y, gridSize, gridSize)
			fireBall.isVisible=true
			fireBall.width=gridSize*3
			fireBall.height=gridSize*3
			audio.play(fireSoundEffect)
			transition.to(fireBall, {time = timeForMoveInMilliseconds+5000, x = -500, onComplete = onCompletecallbackFireball})
		end
		if tom.direction=="down" then
			print("up fireball")
			fireBall=display.newImage("img/tmp-fireball.png", tom.x, tom.y+gridSize, gridSize, gridSize)
			fireBall.isVisible=true
			fireBall.width=gridSize*3
			fireBall.height=gridSize*3
			audio.play(fireSoundEffect)
			transition.to(fireBall, {time = timeForMoveInMilliseconds+5000, y = 1500, onComplete = onCompletecallbackFireball})
		end
		if tom.direction=="right" then
			print("up fireball")
			fireBall=display.newImage("img/tmp-fireball.png", tom.x+gridSize, tom.y, gridSize, gridSize)
			fireBall.isVisible=true
			fireBall.width=gridSize*3
			fireBall.height=gridSize*3
			audio.play(fireSoundEffect)
			transition.to(fireBall, {time = timeForMoveInMilliseconds+5000, x = 1500, onComplete = onCompletecallbackFireball})
		end
		numberOfFireballs=numberOfFireballs-1
	else --freezeball
		if tom.direction=="up" then
			print("up freezeball")
			fireBall=display.newImage("img/tmp-frezeball.png", tom.x, tom.y-gridSize, gridSize, gridSize)
			fireBall.isVisible=true
			transition.to(fireBall, {time = timeForMoveInMilliseconds, alpha = 0, onComplete = onCompletecallbackFrezeball})
		end
		if tom.direction=="left" then
			print("up freezeball")
			fireBall=display.newImage("img/tmp-frezeball.png", tom.x-gridSize, tom.y, gridSize, gridSize)
			fireBall.isVisible=true
			transition.to(fireBall, {time = timeForMoveInMilliseconds, alpha = 0, onComplete = onCompletecallbackFrezeball})
		end
		if tom.direction=="down" then
			print("up freezeball")
			fireBall=display.newImage("img/tmp-frezeball.png", tom.x, tom.y+gridSize, gridSize, gridSize)
			fireBall.isVisible=true
			transition.to(fireBall, {time = timeForMoveInMilliseconds, alpha = 0, onComplete = onCompletecallbackFrezeball})
		end
		if tom.direction=="right" then
			print("up freezeball")
			fireBall=display.newImage("img/tmp-frezeball.png", tom.x+gridSize, tom.y, gridSize, gridSize)
			fireBall.isVisible=true
			transition.to(fireBall, {time = timeForMoveInMilliseconds, alpha = 0, onComplete = onCompletecallbackFrezeball})
		end
		audio.play(freezeSoundEffect)
	end
end



function moveRatLeft(enemy)
	if enemy.direction~="left" then
		--print("direction switched to left")
		clearAllEnemySprites(enemy)
		enemy.facingLeftImg.isVisible=true
	end
	moveInDirection( -moveSpeed, 0 , "left", enemy )
end

function moveRatRight(enemy)
	if enemy.direction~="right" then
		--print("direction switched to right")
		clearAllEnemySprites(enemy)
		enemy.facingRightImg.isVisible=true
	end
	moveInDirection( moveSpeed, 0, "right", enemy )
end

function moveRatUp(enemy)
	if enemy.direction~="up" then
		--print("direction switched to down")
		clearAllEnemySprites(enemy)
		enemy.facingUpImg.isVisible=true
	end
	moveInDirection( 0, -moveSpeed, "up", enemy )
end

function moveRatDown(enemy)
	if enemy.direction~="down" then
		--print("direction switched to down")
		clearAllEnemySprites(enemy)
		enemy.facingDownImg.isVisible=true			
	end
	moveInDirection( 0, moveSpeed, "down", enemy )
end
--screen controller
local fireTimerController
local fireTimerMagic

currentButton=nil
function isWithinBounds( object, event )
	local bounds = object.contentBounds
    local x, y = event.x, event.y
	local isWithinBounds = true
		
	if "table" == type( bounds ) then
		if "number" == type( x ) and "number" == type( y ) then
			isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		end
	end
	print("isWithinBounds:"..tostring(isWithinBounds))
	return  isWithinBounds
end

local function onMouseEvent( event )
	-- Print the mouse cursor's current position to the log.
	if currentButton then
		if isWithinBounds(currentButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			elseif fireTimerMagic then
				timer.cancel( fireTimerMagic )
			end
		end
	end
	--local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
    --print( message )
end
                              
-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )

system.activate( "multitouch" )

local function t( event )
	if currentButton then
		if isWithinBounds(currentButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			elseif fireTimerMagic then
				timer.cancel( fireTimerMagic )
			end
		end
	end
end
 
Runtime:addEventListener( "touch", t )

function myLeftTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
		moveTomLeft()
		currentButton=myLeftButton
		fireTimerController = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, moveTomLeft, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myLeftButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
offsetx=450
offsety=300

local paint = {
    type = "image",
    filename = "img/arrowLeft.png"
}
myLeftButton = display.newRect( 300+offsetx, 300+offsety, 100, 100 )
myLeftButton.fill = paint

myLeftButton:addEventListener( "touch", myLeftTouchListener )  -- Add a "touch" listener to the obj

function myRightTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
		moveTomRight()
		currentButton=myRightButton
		fireTimerController = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, moveTomRight, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myLeftButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local paint = {
    type = "image",
    filename = "img/arrowRight.png"
}
myRightButton = display.newRect( 500+offsetx, 300+offsety, 100, 100 )
myRightButton.fill = paint
myRightButton:addEventListener( "touch", myRightTouchListener )  -- Add a "touch" listener to the obj

local function myUpTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
		moveTomUp()
		currentButton=myUpButton
		fireTimerController = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, moveTomUp, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myUpButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local paint = {
    type = "image",
    filename = "img/arrowUp.png"
}
myUpButton = display.newRect( 400+offsetx, 200+offsety, 100, 100 )
myUpButton.fill = paint
myUpButton:addEventListener( "touch", myUpTouchListener )  -- Add a "touch" listener to the obj

local function myDownTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
		moveTomDown()
		currentButton=myDownButton
		fireTimerController = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, moveTomDown, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myDownButton, event) == false then
			if fireTimerController then
				timer.cancel( fireTimerController )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerController then
			timer.cancel( fireTimerController )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local paint = {
    type = "image",
    filename = "img/arrowDown.png"
}
myDownButton = display.newRect( 400+offsetx, 400+offsety, 100, 100 )
myDownButton.fill = paint
myDownButton:addEventListener( "touch", myDownTouchListener )  -- Add a "touch" listener to the obj

local function myFireTouchListener( event )
    if ( event.phase == "began" ) then
		if fireTimerMagic then
			timer.cancel( fireTimerMagic )
		end
		fireball()
		currentButton=myFireButton
		fireTimerMagic = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, fireball, 0 )
        print( "object touched = " .. tostring(event.target) )  -- "event.target" is the touched object
	elseif ( event.phase == "moved" ) then
		if isWithinBounds(myFireButton, event) == false then
			if fireTimerMagic then
				timer.cancel( fireTimerMagic )
			end
		end
	elseif ( event.phase == "ended" or event.phase == "moved" or event.phase == "cancelled") then
		if fireTimerMagic then
			timer.cancel( fireTimerMagic )
		end
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
local paint = {
    type = "image",
    filename = "img/fireButton.png"
}
myFireButton = display.newRect( offsetx-270, 300+offsety, 100, 100 )
myFireButton.fill = paint
myFireButton:addEventListener( "touch", myFireTouchListener )  -- Add a "touch" listener to the obj

myFireButton.alpha=0.3
myDownButton.alpha=0.3
myUpButton.alpha=0.3
myLeftButton.alpha=0.3
myRightButton.alpha=0.3

function gameloop()
	if gamePaused then
		return
	end
	--moveRatInRandomDirection
	for key, enemy in ipairs(enemies) do
		local direction = math.random(1,4)
		if direction==1 then
			moveRatRight(enemy)
		elseif direction==2 then
			moveRatLeft(enemy)
		elseif direction==3 then
			moveRatUp(enemy)
		elseif direction==4 then
			moveRatDown(enemy)
		end
	end
end

fireRatTimer = timer.performWithDelay( (timeForMoveInMilliseconds+100)*speed, gameloop, 0 )


function detectCollision(x1, y1, width1, height1, x2, y2, width2, height2) 
    if x1 + width1 > x2 and x1 < x2 + width2 and y1 + height1 > y2 and y1 < y2 + height2 then 
        return true
    else
        return false
    end
end
function detectCollision2(movingObject,sprite)
	x1=movingObject.x - (movingObject.width / 2)
	y1=movingObject.y - (movingObject.height / 2)
	width1=movingObject.width
	height1=movingObject.height
	x2=sprite.x - (sprite.width / 2)
	y2=sprite.y - (sprite.height / 2)
	width2=sprite.width 
	height2=sprite.height
	if x1 + width1 > x2 and x1 < x2 + width2 and y1 + height1 > y2 and y1 < y2 + height2 then 
        return true
    else
        return false
    end
end

function detectPoopCollisions(movingObject)
	for key, sprite in pairs(poops) do
        if detectCollision(
                movingObject.x - (movingObject.width / 2),
                movingObject.y - (movingObject.height / 2), 
                movingObject.width, movingObject.height,
                sprite.x - (sprite.width / 2),
                sprite.y - (sprite.height / 2),
                sprite.width, sprite.height
            ) then
            if movingObject.myName == "tom" then
                -- happens when tom moves
                --col.text = debugVersion .. "collision:true"
                --handlePoopCollision(sprite)
            end
			--collided = true
        end
    end
end
--handle keystrokes
local action = {}
function frameUpdate()
	local keyDown = false
	if action["a"] or action["left"] then
		moveTomLeft()
		keyDown = true
	end
	if action["d"] or action["right"] then
		moveTomRight()
		keyDown = true
	end
	if action["w"] or action["up"] then
		moveTomUp()
		keyDown = true
	end
	if action["s"] or action["down"] then
		moveTomDown()
		keyDown = true
	end
	if action["x"] then
		print("action[\"x\"]:"..action["x"])	
	end
	
end

function onKeyEvent( event )
	print("key event")
	if event.phase == "down" then
		print("event.keyName:"..event.keyName)
		action[event.keyName] = true
		keyDown = true
		if event.keyName=="space" or event.keyName=="x" then
			print("fire pressed")
			fireball()
		end
	else
		action[event.keyName] = false
	end
end
Runtime:addEventListener( "enterFrame", frameUpdate )
Runtime:addEventListener( "key", onKeyEvent )
--stop music
audio.stop( 1 )

audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 1, { channel=1 } )


-- Load audio
musicTrack = audio.loadStream( "audio/into-the-battle.mp3",system.ResourceDirectory)


-- Play the background music on channel 1, loop infinitely 
audio.play( musicTrack, { channel=1, loops=-1 } )

--sound effects load
fireSoundEffect = audio.loadStream( "audio/fuego.mp3",system.ResourceDirectory)
freezeSoundEffect = audio.loadStream( "audio/Ice.mp3",system.ResourceDirectory)
mosterDeadSoundEffect = audio.loadStream( "audio/Dead.mp3",system.ResourceDirectory)
gameOverSoundEffect = audio.loadStream( "audio/Gameover.mp3",system.ResourceDirectory)
getStarSoundEffect = audio.loadStream( "audio/glissando.mp3",system.ResourceDirectory)




return scene

--(fixed)fix that the life only goes down when the player is moving, I think i need to detect the collision when the monster is moving
--(done)add quit(what happens when quit? go to menu? go to categories?(decided on go back to menu)) and pause buttons.
--(done)add how many words you got out of 8 in the good job screen
--(fixed)fix the problem with the monsters turning after plaing more than one turn(probably just need to clear timers(it was the timer))
--(dont remember what I did, but ti seems to be fixed in the newest version)BUG:close proximity attack is not working
--(fixed)words are nto capilatized correctly in i18n dictionary in english for category names, or maybe it is in the json file
--(fixed)bug, it is defaulting to slow speed when no option is selected on android...
--(done) reminder, modify the explanation screen for when the person does quiz mode
