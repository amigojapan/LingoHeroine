require("i18n_dict")
--require("trial")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
kanzenban=true
print( "ORIENTATION: "..system.orientation )
function sendToDIfferentTrialStates()
	if kanzenban then
		composer.gotoScene( "difficulty" )
	end
	local trialState=trialAlgorythm()
	if trialState == "Free version" or trialState == "Trial period valid" then
		composer.gotoScene( "difficulty" )
	elseif trialState == "Trial period over" then
		composer.gotoScene( "trialPeriodOver" )
	elseif trialState == "Trial period start" then
		composer.gotoScene( "trialPeriodStart" )
	end
end
local function backToMainMenu()
	composer.gotoScene( "menu" )
end

local function setHalfSpeed()
	composer.setVariable( "speed", "2" )
	composer.gotoScene( "menu" )
end

local function setFullSpeed()
	composer.setVariable( "speed", "1" )
	composer.gotoScene( "menu" )
end

local function gotoHighScores()
	composer.gotoScene( "scoresScreen" )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		print("Removed scene")
		--composer.removeScene( "game" )
		local background = display.newImageRect( sceneGroup, "backgrounds/background.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )

		offsetY=150	
		local lblTitle = display.newText( sceneGroup, "Settings", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 75 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )

		offsetY=offsetY+75
		local lblTitle = display.newText( sceneGroup, "設定", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 75 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )

		offsetY=offsetY+75
		local lblTitle = display.newText( sceneGroup, "Configuracion", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 75 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		--local title = display.newImageRect( sceneGroup, "img/tom burger 3 title.png", 676, 97 )
		--title.x = display.contentCenterX
		--title.y = 200
	
	
		offsetY=500
		local startButtonEnglish = display.newText( sceneGroup, "Fast、早い, Rapido", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonEnglish:setFillColor( 0.82, 0.86, 1 )
		startButtonEnglish:addEventListener( "tap", setFullSpeed )
	
		offsetY=offsetY+55
		translate=i18n_setlang("Japanese")
		local startButtonJapanese = display.newText( sceneGroup, "Slow、遅い, Despacio", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonJapanese:setFillColor( 0.82, 0.86, 1 )
		startButtonJapanese:addEventListener( "tap", setHalfSpeed )
	
		local highScoresButton = display.newText( sceneGroup, "<<", 300, 50, "fonts/ume-tgc5.ttf", 44 )
		highScoresButton:setFillColor( 0.75, 0.78, 1 )
	
		highScoresButton:addEventListener( "tap", backToMainMenu )
	
	end
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

return scene
