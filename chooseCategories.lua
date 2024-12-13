require("i18n_dict")
require("trial")
local json = require( "json" )

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoCategory(event)
	composer.setVariable( "category", event.target.value )
	if composer.getVariable("gameMode")  == "Dictionary" then
		composer.gotoScene( "Dictionary" )	
	else
		composer.gotoScene( "game" )
	end
end

function gotoChooseGameMode()
	composer.gotoScene( "chooseGameMode" )
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
		local lblTitle = display.newText( sceneGroup, translate["Choose Category"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		

		offsetY=offsetY+100
		-- Path for the file to read
		local path = system.pathForFile("words1.json", system.ResourceDirectory) -- Get the path to the file
		--local path = "words1.json"--system.pathForFile( filename, loc )
		
		-- Open the file handle
		local file, errorString = io.open( path, "r" )
		words={}
		if not file then
			-- Error occurred; output the cause
			print( "File error: " .. errorString )
		else
		-- Read data from file
		local contents = file:read( "*a" )
		-- Decode JSON data into Lua table
		local data = json.decode( contents )
		-- Close the file handle
		io.close( file )

		categoryNames = getCategoryNames(data)
		offsetX=325
		counter=0

			for key,value in ipairs(categoryNames) do
				if counter== 10 then--count 10 lines
					offsetY=150
					offsetX=750
				end
				counter=counter+1
				categoryTranslated=translate[value]
				if categoryTranslated==nil then
					categoryTranslated=value
				end
				local lblTitle = display.newText( sceneGroup, categoryTranslated, offsetX, offsetY, "fonts/ume-tgc5.ttf", 40 )
				lblTitle.value=value
				lblTitle:setFillColor( 0.82, 0.86, 1 )
				offsetY=offsetY+50
				lblTitle:addEventListener( "tap", gotoCategory )
			end
		end
		local btnBack = display.newText( sceneGroup, "<<", 200, 20, "fonts/ume-tgc5.ttf", 44 )
		btnBack:setFillColor( 0.75, 0.78, 1 )
		btnBack:addEventListener( "tap", gotoChooseGameMode )	
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
