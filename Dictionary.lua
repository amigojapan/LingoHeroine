require("i18n_dict")
local media = require("media")
local audio = require("audio")
local widget = require( "widget" )
local json = require( "json" )
local composer = require( "composer" )
--local socket = require("socket")--for sleep command

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Variables for recording
local recordingPath
local isRecording = false
local recorder
translation=nil
language1=nil
language2=nil
category=composer.getVariable("category")
data=nil
clickedNativeLanguage=nil
wordLastClicked=""
translatedWord=""
clock = os.clock
function sleep(time)
	startTime=clock()
	print("startTime:"..startTime)
	endTime=startTime+time
	print("endTime:"..endTime)
	repeat
	   startTime=clock()
	until( startTime>=endTime )
end

local function getAllWordsInCategory(parsedData, language, category)
    local wordsInCategory = {}

    -- Iterate through each category in the parsed data
    for _, categoryData in ipairs(parsedData) do
        -- Check if the category matches
        if categoryData.category == category then
            -- Iterate through each word in the category
            for _, wordData in ipairs(categoryData.words) do
                -- Extract the word in the specified language
                table.insert(wordsInCategory, wordData[language])
            end
            -- Since category names are unique, we can exit the loop early
            break
        end
    end

    return wordsInCategory
end

function renameRomajiToJapanese()
	print("rename japanese animelas clicked")
	language1="Japanese"
	language2="Romaji"
	animalwordsJapanese=getAllWordsInCategory(data,language1,category)
    animalwordsRomaji=getAllWordsInCategory(data,language2,category)
	for key, RomajiWord in ipairs(animalwordsRomaji) do
		pathSource=system.pathForFile("flat/"..language1.."/"..RomajiWord..".mp3", system.ResourceDirectory)
		pathDest=system.pathForFile("flat/"..language1.."/".. animalwordsJapanese[key]..".mp3", system.ResourceDirectory)
		print("renaming:"..pathSource.." to :"..pathDest)
		os.rename(pathSource, pathDest)
	end
end
function translateWordToStudyLanguage(wordToTranlsate,category)
	print("tranlation executing, wordToTranlsate:"..wordToTranlsate.." langauge1:"..language1.." langauge2:"..language2.." category:"..category)
	language1Table=getAllWordsInCategory(data,language1,category)
    language2Table=getAllWordsInCategory(data,language2,category)
	for key, word in ipairs(language1Table) do
		if wordToTranlsate == word then
			print(word.." = "..language2Table[key])
			return word, language2Table[key]
		end
	end
end

-- Function to start recording
local function startRecording()
	recordingPath = system.pathForFile("flat/"..language1.."/"..translation.text..".mp3", system.ResourceDirectory)
    if isRecording then
        print("Already recording...")
        return
    end

    print("Recording started...")
    recorder = media.newRecording(recordingPath)
    recorder:startRecording()
    isRecording = true
end

-- Function to stop recording
local function stopRecording()
    if not isRecording then
        print("No recording to stop.")
        return
    end

    recorder:stopRecording()
    print("Recording stopped. File saved at:", recordingPath)
    isRecording = false
end

waitTime=nil
if system.getInfo("environment") == "browser" then
	waitTime=.2
else
    waitTime=2
end

function wait(waitTime)
    timer = os.time()
    repeat until os.time() > timer + waitTime
end

-- Function to play back the recorded sound
local function playRecording()
    if isRecording then
        print("Stop recording before playback.")
        return
    end
	--wordLastClicked=""
	--translatedWord=""
	if not language1 then
		translation.text=translate["No dictionary selected..."]
		return
	end
	--[[
	recordedSound = audio.loadStream("flat/"..language1.."/".. wordLastClicked ..".mp3", system.ResourceDirectory)
    if recordedSound then
        print("Playing recorded sound...")
        audio.play(recordedSound)
    else
        print("No recording found!")
    end
	--socket.sleep(3)
	--sleep(waitTime)
	wait(3)
	]]
	if clickedNativeLanguage==true then
		word = translatedWord
	elseif clickedNativeLanguage==false then
		word = wordLastClicked
	end
	
	recordedSound = audio.loadStream("flat/"..studyLanguage.."/".. word  ..".mp3", system.ResourceDirectory)
    if recordedSound then
        print("Playing recorded sound...")
        audio.play(recordedSound)
    else
        print("No recording found!")
    end
end

startButton=nil
stopButton=nil
playButton=nil
tableView=nil
local function chooseCategory(event)
	playButton.isVisible=false
	playButton:removeSelf()
	if tableView then
		tableView:removeSelf()
	end
	--startButton:removeSelf()
	--stopButton:removeSelf()
	
	composer.gotoScene( "chooseCategories" )
end

function gotoChooseStudyLanguage()
	composer.gotoScene( "chooseStudyLanguage" )
end
wordsFullStudyLangauge={}
wordsFullTargetLangauge={}
-- Path for the file to read
local path = system.pathForFile("words1.json", system.ResourceDirectory) -- Get the path to the file
--local path = "words1.json"--system.pathForFile( filename, loc )
 
-- Open the file handle
local file, errorString = io.open( path, "r" )
-- Read data from file
local contents = file:read( "*a" )
-- Decode JSON data into Lua table
data = json.decode( contents )
-- Close the file handle
io.close( file )
local function getAllWordsInLanguage(parsedData, language)
    local wordsInLanguage = {}

    -- Iterate through each category in the parsed data
    for _, categoryData in ipairs(parsedData) do
        -- Iterate through each word in the category
        for _, wordData in ipairs(categoryData.words) do
            -- Extract the word in the specified language
            table.insert(wordsInLanguage, wordData[language])
        end
    end

    return wordsInLanguage
end

local function getWords(language,table1,categoryName, wordCount)
    local Words = {}
    
    for _, category in ipairs(table1) do
        if category.category == categoryName then
            for i, word in ipairs(category.words) do
                if language == "English" then
                    table.insert(Words, word.English)
                elseif language == "Japanese" then
                    table.insert(Words, word.Japanese)
                elseif language == "Romaji" then
                    table.insert(Words, word.Romaji)
                elseif language == "Spanish" then
                    table.insert(Words, word.Spanish)
                end
                --Words.correct=true
            end
        end
    end

    --shuffleTable(Words)

    local WordsCounted = {}
    
    for i = 1, wordCount do
        table.insert(WordsCounted, Words[i])
    end
    
    return WordsCounted
end
local function onRowRender(event)
	local row = event.row
	local params = row.params

	-- Create a text object for the row's content
	local rowText = display.newText({
		text = params.filename, -- Use the filename from the params
		x = row.contentWidth * 0.5,
		y = row.contentHeight * 0.5,
		font = "fonts/ume-tgc5.ttf",
		fontSize = 16,
		align = "left"
	})

	rowText:setFillColor(0) -- Set text color to black
	row:insert(rowText) -- Insert the text into the row
end

local function onRowTouch(event)
    local row = event.target
    local params = row.params -- Retrieve the params passed to the row

    if event.phase == "began" then
        -- Highlight the row (optional)
        row.alpha = 0.5
        print("Touched row: " .. params.filename)

    elseif event.phase == "moved" then
        -- Optionally handle drag or movement
        print("Moving on row: " .. params.filename)

    elseif event.phase == "release" then
        -- Perform action when row is clicked (released)
        row.alpha = 1 -- Restore row alpha
        print("Clicked row: " .. params.filename)
        -- Custom logic: open file, change scene, etc.

		wordLastClicked,translatedWord=translateWordToStudyLanguage(params.filename,category)
		translation.text= wordLastClicked.." = "..translatedWord
	end
    return true -- Prevent touch propagation to other objects
end



local language1Words
local language2Words

function displayDictionary()
	--**start here
	--local language1Words=getAllWordsInLanguage(data, language1 )
	--local language1Words=getAllWordsInLanguage(data, language2 )
	category = composer.getVariable( "category" )
	language1Words = getWords(language1,data,category, 20)--get all words?
	language2Words = getWords(language2,data,category, 20)--get all words?

	for i, v in ipairs(language1Words) do
		print(v)
	end
	if tableView then
		tableView:removeSelf()
	end
	tableView = widget.newTableView(
		{
			left = 700,
			top = 0,
			height = 900,
			width = 300,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener
		}
	)
	
	for _, file in ipairs(language1Words) do
		print("file:"..file)
		-- Insert a row into the tableView
		tableView:insertRow{
			rowHeight = 40,
			params = { filename = file }
		} -- Pass file name as parameter}
	end

end

local function displayNativeLanguageDictionary(event)
	clickedNativeLanguage=true
	language1=language
	language2=studyLanguage
	displayDictionary()
end

local function displayForeignLanguageDictionary(event)
	clickedNativeLanguage=false
	language1=studyLanguage
	language2=language
	displayDictionary()
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

translate=nil
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
		studyLanguage=composer.getVariable( "studyLanguage" )
		print("language:"..language)
		print("studyLanguage:"..studyLanguage)
		translate=i18n_setlang(language)
		ordersRectangle = display.newRect(sceneGroup,display.contentCenterX, display.contentCenterY, 1000-100, 800-50 )
		ordersRectangle.strokeWidth = 5
		ordersRectangle:setFillColor( 0, 0 , 0, 0.5 )
		ordersRectangle:setStrokeColor( 1, 0, 0 )
		
		offsetY=50
		local lblTitle = display.newText( sceneGroup, translate["Dictionary"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		

		offsetY=offsetY+50
		-- Path for the file to read
		--["Native Language Dictionary"]="Diccionario en idioma nativo",
		--["Foreign Language Dictionary"]="Diccionario en idioma extranjero",
	
		local btnPlay = display.newText( sceneGroup, translate["Native Language Dictionary"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnPlay:setFillColor( 0.82, 0.86, 1 )
		btnPlay:addEventListener( "tap",displayNativeLanguageDictionary )

		offsetY=offsetY+50
		local btnStudy = display.newText( sceneGroup, translate["Foreign Language Dictionary"], display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		btnStudy:setFillColor( 0.82, 0.86, 1 )
		btnStudy:addEventListener( "tap", displayForeignLanguageDictionary )

		offsetY=offsetY+50
		translation = display.newText( sceneGroup, "", display.contentCenterX, offsetY, "fonts/ume-tgc5.ttf", 40 )
		translation:setFillColor( 0.82, 0.86, 1 )
		--translation:addEventListener( "tap", displayForeignLanguageDictionary )

		local btnBack = display.newText( sceneGroup, "<<", 200, 20, "fonts/ume-tgc5.ttf", 44 )
		btnBack:setFillColor( 0.75, 0.78, 1 )
		btnBack:addEventListener( "tap", chooseCategory )	

		--startButton = display.newText("Start Recording", display.contentCenterX, display.contentCenterY - 50, native.systemFont, 20)
		--startButton:setFillColor(0, 1, 0)
		
		--stopButton = display.newText("Stop Recording", display.contentCenterX, display.contentCenterY, native.systemFont, 20)
		--stopButton:setFillColor(1, 0, 0)
		
		playButton = display.newText("Play Recording", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 50)
		playButton:setFillColor(0, 0, 1)
		
		-- Add event listeners
		--startButton:addEventListener("tap", startRecording)
		--stopButton:addEventListener("tap", stopRecording)
		playButton:addEventListener("tap", playRecording)

		--renameButton = display.newText("rename animals", display.contentCenterX, display.contentCenterY + 100, native.systemFont, 20)
		--renameButton:setFillColor(1, 1, 0)
		
		-- Add event listeners
		--renameButton:addEventListener("tap", renameRomajiToJapanese)

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
--to convert an entire directory of wav files, use:
--	find . -maxdepth 1 -type f -name \*.wav -exec sh -c 'NAME=`basename "$1" | sed s/.wav//` ; ffmpeg -i "${NAME}.wav" -acodec mp3 -ab 64k ${NAME}.mp3' find-sh {} \;
--	or
--(used this) for file in *.wav; do ffmpeg -i "$file" -acodec mp3 -ab 64k "${file%.wav}.mp3"; done
--	Thurmond> RayTracer, won't work well if there are spaces in the file 
--
--	actually the second solution worked with large filenames, and hte first one did not
--(fixed,I changed those colors to other colors)ai overlaps with colors and emotions in Japanese
--	(also naranja in Spanish)orange overlaps with fruits and colors in english
--(fixed )dictionary remains on screen after clicking another language  and then clicking <<