require("i18n_dict")
require("trial")
local json = require( "json" )

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoPlay(event)
	composer.setVariable( "gameMode", "Play" )
	composer.gotoScene( "chooseCategories" )
end

function gotoChooseStudyLanguage()
	composer.gotoScene( "chooseStudyLanguage" )
end

local function gotoStudy(event)
	composer.setVariable( "gameMode", "Study" )
	composer.gotoScene( "chooseCategories" )
end

local function gotoDictionary(event)
	composer.setVariable( "gameMode", "Dictionary" )
	composer.gotoScene( "chooseCategories" )
end

local function getCategoryNames(parsedData)
    local categoryNames = {}

    -- Iterate through parsedData to extract category names
    for _, categoryData in ipairs(parsedData) do
        table.insert(categoryNames, categoryData.category)
    end

    return categoryNames
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
		--print("Removed scene")
		--composer.removeScene( "game" )
		local background = display.newImageRect( sceneGroup, "backgrounds/background.png", 1400,800 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		language=composer.getVariable( "language" )
		print("language:"..language)
		translate=i18n_setlang(language)
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )
		
		offsetY=50
		local lblTitle = display.newText( sceneGroup, translate["Choose Game Mode"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		

		offsetY=offsetY+100
		-- Path for the file to read
		local btnPlay = display.newText( sceneGroup, translate["Play"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnPlay:setFillColor( 0.82, 0.86, 1 )
		btnPlay:addEventListener( "tap", gotoPlay )

		offsetY=offsetY+50
		local btnStudy = display.newText( sceneGroup, translate["Study"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnStudy:setFillColor( 0.82, 0.86, 1 )
		btnStudy:addEventListener( "tap", gotoStudy )

		offsetY=offsetY+50
		local btnStudy = display.newText( sceneGroup, translate["Dictionary"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnStudy:setFillColor( 0.82, 0.86, 1 )
		btnStudy:addEventListener( "tap", gotoDictionary )

		local btnBack = display.newText( sceneGroup, "<<", 200, 20, "fonts/ume-tgc5.ttf", 44 )
		btnBack:setFillColor( 0.75, 0.78, 1 )
		btnBack:addEventListener( "tap", gotoChooseStudyLanguage )	
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
