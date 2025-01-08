require("i18n_dict")
require("trial")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

print( "ORIENTATION: "..system.orientation )
function sendToDIfferentTrialStates()
	local trialState=trialAlgorythm()
	if trialState == "Free version" or trialState == "Trial period valid" then
		composer.gotoScene( "chooseStudyLanguage" )
	elseif trialState == "Trial period over" then
		composer.gotoScene( "trialPeriodOver" )
	elseif trialState == "Trial period start" then
		composer.gotoScene( "trialPeriodStart" )
	end
end

local function gotoSettingsMenu()
	composer.gotoScene( "SettingsMenu" )
end

local function setDefaultSpeed()
	speed = composer.getVariable( "speed" )
	if not speed then
		speed="1"
	end
	print("speed:"..speed)
	composer.setVariable( "speed", speed )
end


function gotoStudyLanguageRomajiInRomaji()
	composer.setVariable( "language", "Romaji" )
	sendToDIfferentTrialStates()
end

local function gotoGameEnglish()
	composer.setVariable( "language", "English" )
	sendToDIfferentTrialStates()
end

local function gotoGameJapanese()
	composer.setVariable( "language", "Japanese" )
	sendToDIfferentTrialStates()
end

local function gotoGameSpanish()
	composer.setVariable( "language", "Spanish" )
	sendToDIfferentTrialStates()
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

audio.reserveChannels( 1 )
	--stop music
	audio.stop( 1 )
	-- Reduce the overall volume of the channel
	audio.setVolume( 0.3, { channel=1 } )


	-- Load audio
	musicTrack = audio.loadStream( "audio/Base-Game-Loop.mp3",system.ResourceDirectory)


	-- Play the background music on channel 1, loop infinitely 
	audio.play( musicTrack, { channel=1, loops=-1 } )


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
		
		offsetY=50
		local lblTitle = display.newText( sceneGroup, "Lingo Heroine", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		
		offsetY=offsetY+100
		local lblTitle = display.newText( sceneGroup, "Player's language", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )

		offsetY=offsetY+50
		local lblTitle = display.newText( sceneGroup, "プレイヤー言語", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )

		offsetY=offsetY+50
		local lblTitle = display.newText( sceneGroup, "Idioma del Jugador", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )

		--local title = display.newImageRect( sceneGroup, "img/tom burger 3 title.png", 676, 97 )
		--title.x = display.contentCenterX
		--title.y = 200
	
	
		offsetY=450
		translate=i18n_setlang("English")
		local startButtonEnglish = display.newText( sceneGroup, translate["Language"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonEnglish:setFillColor( 0.82, 0.86, 1 )
		startButtonEnglish:addEventListener( "tap", gotoGameEnglish )
	
		offsetY=offsetY+55
		translate=i18n_setlang("Japanese")
		local startButtonJapanese = display.newText( sceneGroup, translate["Language"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonJapanese:setFillColor( 0.82, 0.86, 1 )
		startButtonJapanese:addEventListener( "tap", gotoGameJapanese )

		offsetY=offsetY+55
		translate=i18n_setlang("Romaji")
		local startButtonRomaji = display.newText( sceneGroup, translate["Language"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonRomaji:setFillColor( 0.82, 0.86, 1 )
		startButtonRomaji:addEventListener( "tap", gotoStudyLanguageRomajiInRomaji )
		

		offsetY=offsetY+55
		translate=i18n_setlang("Spanish")
		local startButtonSpanish = display.newText( sceneGroup, translate["Language"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonSpanish:setFillColor( 0.82, 0.86, 1 )
		startButtonSpanish:addEventListener( "tap", gotoGameSpanish )

		offsetY=offsetY+55
		local startButtonSpanish = display.newText( sceneGroup, "Settings, 設定, Opciones", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 44 )
		startButtonSpanish:setFillColor( 0.82, 0.86, 1 )
		startButtonSpanish:addEventListener( "tap", gotoSettingsMenu )

	
		--local highScoresButton = display.newText( sceneGroup, "Scores,スコア、Puntuaje", display.contentCenterX, 720, "fonts/ume-tgc5.ttf", 44 )
		--highScoresButton:setFillColor( 0.75, 0.78, 1 )
	
		--highScoresButton:addEventListener( "tap", gotoHighScores )
	
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
