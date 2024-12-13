require("i18n_dict")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
url=nil

print( "ORIENTATION: "..system.orientation )

local function gotoMenu()
	composer.gotoScene( "menu" )
end

local function gotoURL()
	system.openURL( url )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "backgrounds/background.png", 1400,800 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
	ordersRectangle.strokeWidth = 5
	ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
	ordersRectangle:setStrokeColor( 1, 0, 0 )
	language=composer.getVariable( "language" )
	if language=="English" then
		story = display.newImageRect( sceneGroup, "backgrounds/trialEndEnglish.png", 1000,800 )
		url="https://amjp.psy-k.org/tom-burger/Play-Tom-Burger-HTML5.html"
	elseif language=="Japanese" then
		story = display.newImageRect( sceneGroup, "backgrounds/trialEndJapanese.png", 1000,800 )
		url="https://amjp.psy-k.org/tom-burger//Play-Tom-Burger-HTML5-jp.html"
	elseif language=="Spanish" then
		story = display.newImageRect( sceneGroup, "backgrounds/trialEndSpanish.png", 1000,800 )
		url="https://amjp.psy-k.org/tom-burger//Play-Tom-Burger-HTML5-es.html"
	end
	story.x = display.contentCenterX
	story.y = display.contentCenterY

	local lblTitle = display.newText( sceneGroup, "Trial end", display.contentCenterX, 50, "fonts/ume-tgc5.ttf", 75 )
	lblTitle:setFillColor( 0.82, 0.86, 1 )

	local highScoresButton = display.newText( sceneGroup, "purchase, 購入、comprar", display.contentCenterX, 720, "fonts/ume-tgc5.ttf", 44 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
	highScoresButton:addEventListener( "tap", gotoURL )

	local playButton = display.newText( sceneGroup, "<<", 300, 50, "fonts/ume-tgc5.ttf", 44 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton:addEventListener( "tap", gotoMenu )

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
		composer.removeScene( "game" )
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
