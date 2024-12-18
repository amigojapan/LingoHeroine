require("i18n_dict")
require("trial")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function gotoStudyLanguageJapanese()
	composer.setVariable( "studyLanguage", "Japanese" )
	composer.gotoScene( "chooseGameMode" )
end

function gotoStudyLanguageRomaji()
	composer.setVariable( "studyLanguage", "Romaji" )
	composer.gotoScene( "chooseGameMode" )
end

function gotoStudyLanguageRomajiInRomaji()
	composer.setVariable( "language", "Romaji" )
	composer.setVariable( "studyLanguage", "Romaji" )
	composer.gotoScene( "chooseGameMode" )
end

function gotoMenu()
	composer.gotoScene( "menu" )
end

function gotoStudyLanguageSpanish()
	composer.setVariable( "studyLanguage", "Spanish" )
	composer.gotoScene( "chooseGameMode" )
end

function gotoStudyLanguageEnglish()
	composer.setVariable( "studyLanguage", "English" )
	composer.gotoScene( "chooseGameMode" )
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
		
		offsetY=50
		local lblTitle = display.newText( sceneGroup, "Choose Study Language", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		
		offsetY=offsetY+100
		language = composer.getVariable("language")
		if language == "English" then
			btn1 = display.newText( sceneGroup, "Study Japanese Difficult", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn1:setFillColor( 0.82, 0.86, 1 )
			btn1:addEventListener("tap", gotoStudyLanguageJapanese)

			offsetY=offsetY+50
			btn3 = display.newText( sceneGroup, "Study Romanized Japanese", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn3:setFillColor( 0.82, 0.86, 1 )				
			btn3:addEventListener("tap", gotoStudyLanguageRomaji)
			
			offsetY=offsetY+50
			btn2 = display.newText( sceneGroup, "Study Spanish", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn2:setFillColor( 0.82, 0.86, 1 )				
			btn2:addEventListener("tap", gotoStudyLanguageSpanish)

			offsetY=offsetY+50
			btn4 = display.newText( sceneGroup, "Study English", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn4:setFillColor( 0.82, 0.86, 1 )
			btn4:addEventListener("tap", gotoStudyLanguageEnglish)

		elseif language == "Japanese" then
			btn1 = display.newText( sceneGroup, "英語を勉強する", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn1:setFillColor( 0.82, 0.86, 1 )
			btn1:addEventListener("tap", gotoStudyLanguageEnglish)
			
			offsetY=offsetY+50
			btn2 = display.newText( sceneGroup, "スペイン語を勉強する", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn2:setFillColor( 0.82, 0.86, 1 )				
			btn2:addEventListener("tap", gotoStudyLanguageSpanish)

			offsetY=offsetY+50
			btn4 = display.newText( sceneGroup, "日本語を漢字で勉強する", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn4:setFillColor( 0.82, 0.86, 1 )
			btn4:addEventListener("tap", gotoStudyLanguageJapanese)

			offsetY=offsetY+50
			btn3 = display.newText( sceneGroup, "Nigongo wo romaji de benkyou suru", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn3:setFillColor( 0.82, 0.86, 1 )				
			btn3:addEventListener("tap", gotoStudyLanguageRomajiInRomaji)
		elseif language == "Romaji" then
			btn1 = display.newText( sceneGroup, "eigo wo benkyou suru", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn1:setFillColor( 0.82, 0.86, 1 )
			btn1:addEventListener("tap", gotoStudyLanguageEnglish)
			
			offsetY=offsetY+50
			btn2 = display.newText( sceneGroup, "supeingo wo benkyou suru", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn2:setFillColor( 0.82, 0.86, 1 )				
			btn2:addEventListener("tap", gotoStudyLanguageSpanish)

			offsetY=offsetY+50
			btn4 = display.newText( sceneGroup, "nihongo wo kanji de benkyou suru", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn4:setFillColor( 0.82, 0.86, 1 )
			btn4:addEventListener("tap", gotoStudyLanguageJapanese)

			offsetY=offsetY+50
			btn3 = display.newText( sceneGroup, "Nigongo wo romaji de benkyou suru", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn3:setFillColor( 0.82, 0.86, 1 )				
			btn3:addEventListener("tap", gotoStudyLanguageRomajiInRomaji)

		elseif language == "Spanish" then
			btn1 = display.newText( sceneGroup, "Estudiar Japones", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn1:setFillColor( 0.82, 0.86, 1 )
			btn1:addEventListener("tap", gotoStudyLanguageJapanese)

			offsetY=offsetY+50
			btn3 = display.newText( sceneGroup, "Estudiar Japones Romanizado", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn3:setFillColor( 0.82, 0.86, 1 )				
			btn3:addEventListener("tap", gotoStudyLanguageRomaji)
			
			offsetY=offsetY+50
			btn2 = display.newText( sceneGroup, "Estudiar Ingles", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn2:setFillColor( 0.82, 0.86, 1 )				
			btn2:addEventListener("tap", gotoStudyLanguageEnglish)

			offsetY=offsetY+50
			btn4 = display.newText( sceneGroup, "Esrudiar Español", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
			btn4:setFillColor( 0.82, 0.86, 1 )				
			btn4:addEventListener("tap", gotoStudyLanguageSpanish)

		end

		local btnBack = display.newText( sceneGroup, "<<", 200, 20, "fonts/ume-tgc5.ttf", 44 )
		btnBack:setFillColor( 0.75, 0.78, 1 )
		btnBack:addEventListener( "tap", gotoMenu )	

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
