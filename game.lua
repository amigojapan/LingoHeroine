
local composer = require( "composer" )
local clock = os.clock

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
timerEverySecond=nil
studyLanguage=nil
speed = composer.getVariable( "speed" )
if speed=="2" then
	speed=2
else
	speed=1
end

function playWord(language,word)
    local recordedSound = audio.loadStream("flat/"..language.."/"..word..".mp3", system.ResourceDirectory)
    if recordedSound then
        print("Playing recorded sound...")
        audio.play(recordedSound)
    else
        print("No recording found!")
    end
end
local function gotoCategories(event)
    if timerEverySecond then
        timer.cancel(timerEverySecond)
    end
    hideEverything()
    composer.removeScene("game")
	composer.gotoScene( "chooseCategories" )
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
        local json = require( "json" )

-- Function to shuffle a table (Fisher-Yates algorithm)
local function shuffleTable(t)
    local rand = math.random
    for i = #t, 2, -1 do
        local j = rand(1, i)
        t[i], t[j] = t[j], t[i]
    end
end

-- Function to get a total number of random words in a specific language, excluding one category
local function getRandomWordsFromJsonInLanguageExcluding(language, jsonData, excludeCategory, totalWordCount)
    local allWords = {}
    
    -- Collect words from all categories except the excluded one
    for _, categoryData in ipairs(jsonData) do
        if categoryData.category ~= excludeCategory then
            for _, word in ipairs(categoryData.words) do
                -- Insert only the word in the specified language
                table.insert(allWords, word[language])
            end
        end
    end

    -- Now that we have all the words, randomly select from them
    local selectedWords = {}
    local wordsToSelect = math.min(totalWordCount, #allWords)

    for i = 1, wordsToSelect do
        local randomIndex = math.random(1, #allWords)
        table.insert(selectedWords, allWords[randomIndex])

        -- Optionally remove the selected word to avoid duplicates
        table.remove(allWords, randomIndex)
    end

    local btnBack = display.newText( sceneGroup, "<<", 200, 20, "fonts/ume-tgc5.ttf", 44 )
    btnBack:setFillColor( 0.75, 0.78, 1 )
    btnBack:addEventListener( "tap", gotoCategories )	

    return selectedWords
end

-- Function to get the first n Japanese words from a specific category
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

    shuffleTable(Words)

    local WordsCounted = {}
    
    for i = 1, wordCount do
        table.insert(WordsCounted, Words[i])
    end
    
    return WordsCounted
end

-- Function to get random Japanese words from non-verb categories
local function getRandomWords(language,table1,excludeCategory, wordCount)
    local allWords = {}
    
    -- Collect words from all categories except the excluded one (e.g., "verb")
    for _, category in ipairs(table1) do
        if category.category ~= excludeCategory then
            for _, word in ipairs(category.words) do
                if language == "English" then
                    table.insert(allWords, word.English)
                elseif language == "Japanese" then
                    table.insert(allWords, word.Japanese)
                elseif language == "Japanese" then
                    table.insert(allWords, word.Spanish)
                end
                --allWords.correct=false
            end
        end
    end
    
    -- Get the first 'wordCount' random words
    local randomWords = {}
    for i = 1, wordCount do
        table.insert(randomWords, allWords[i])
    end
    
    return randomWords
end

 -- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
  end
  
local function concatenateTables(t1, t2)
    local result = {}

    -- Add all elements from the first table
    for i = 1, #t1 do
        table.insert(result, t1[i])
    end

    -- Add all elements from the second table
    for i = 1, #t2 do
        table.insert(result, t2[i])
    end

    return result
end

-- Path for the file to read
local path = system.pathForFile("words1.json", system.ResourceDirectory) -- Get the path to the file
--local path = "words1.json"--system.pathForFile( filename, loc )
 
-- Open the file handle
local file, errorString = io.open( path, "r" )
pointCount=0
wrongAnswers=0
iconsOffsetX=15
iconsOffsetY=700
iconsTable={}
tapTimer=nil

function handleTapEvent(event)
    if studyMode then
        --flip languages
        if event.target.clicked==true then
            print("event.target.text:"..event.target.text)
            print("event.target.nativeLanguage:"..event.target.nativeLanguage)
            print("event.target.foreingAnswer:"..event.target.foreingAnswer)
            if event.target.text==event.target.nativeLanguage then
                event.target.text=event.target.foreingAnswer
            else
                event.target.text=event.target.nativeLanguage
            end
            return
        end
    end
    event.target.clicked=true
    
    local wordFound=false
    local answer=event.target.text
    
    event.target.foreingAnswer=event.target.text
    print("event.target.foreingAnswer when set:"..event.target.foreingAnswer)
    
    local word="empty"
    for key, word in ipairs(words) do
        if answer == word then
            wordFound=true
            break
        end
    end
    if wordFound then
        if studyMode then
            local targetword
            for i, word in ipairs(wordsFullStudyLangauge) do
                if word==event.target.text then
                    targetword=wordsFullTargetLangauge[i]
                    break
                end
            end
            event.target.text=targetword
            event.target.nativeLanguage=event.target.text
            print("event.target.nativeLanguage when set:"..event.target.nativeLanguage)    
            event.target:setFillColor(0,1,0)
            event.target.correctAnswer=true
        else
            event.target.text="✔"
        end
        event.target.right=true
        pointCount=pointCount+1
        audio.play(rightSoundEffect)
        --add star icons
        sprite=display.newImage("img/power-up.png", iconsOffsetY, iconsOffsetX, 16, 16)
        table.insert(iconsTable,sprite)
        iconsOffsetY=iconsOffsetY+16--make space for next icon
        if pointCount == 8 and wrongAnswers == 0 then
            hideEverything()
            composer.gotoScene( "perfectScoreScreen" )
        end
    elseif event.target.text=="✔" then
        event.target.correctAnswer=true
        return
    else
        if event.target.correctAnswer==false then
            return -- this fixed the problem of red words dissapearing in play mode
        end
        local targetword
        for i, word in ipairs(wordsFullStudyLangauge) do
            if word==event.target.text then
                targetword=wordsFullTargetLangauge[i]
                break
            end
        end
        event.target.text=targetword
        event.target.nativeLanguage=event.target.text
        print("event.target.nativeLanguage when set:"..event.target.nativeLanguage)    
        event.target:setFillColor(1,0,0)
        event.target.right=false
        event.target.correctAnswer=false
        wrongAnswers=wrongAnswers+1
        audio.play(wrongSoundEffect)
        --add monster icons
        color=math.random(1,2)
        if color==1 then
            sprite=display.newImage("img/purpleSlimeFacingFoward.png", iconsOffsetY, iconsOffsetX, 16, 16)
        elseif color==2 then
            sprite=display.newImage("img/greenSlimeFacingFoward.png", iconsOffsetY, iconsOffsetX, 16, 16)
        end
        table.insert(iconsTable, sprite)
        iconsOffsetY=iconsOffsetY+16--make space for next icon
    end    
end
timeOut=nil
if system.getInfo("environment") == "browser"  then
	timeOut=.3
else
    timeOut=.03
end
local platform = system.getInfo("platform")
if platform == "win32" or platform == "win64" then
	print("rinning on windows")
	--timeOut=0.15000000000003
	timeOut=0.20
end

function functTapListener(event)
    print("tap listener called, phase:"..event.phase)
    --event.target.isVisible=false
    --flip between languages
    if event.phase == "began" then
        print("tap began")
        tapTimer = clock()
        print("tapTimer:"..tapTimer)
        --specify the global touch focus
        --display.getCurrentStage():setFocus( self )
        --self.isFocus = true
        
    --elseif self.isFocus then

        
    elseif event.phase == "ended" or event.phase == "cancelled" then
        print("tap ended")
        -- reset global touch focus
        --display.getCurrentStage():setFocus( nil )
        --self.isFocus = nil
        print("clock()-tapTimer:"..clock()-tapTimer.." timeOut:"..timeOut.." condition clock()-tapTimer <= timeOut")
        --if system.getInfo("platform") == "android"  then
        --    physics.setScale( 40 )	
        --end
        
        if clock()-tapTimer <= timeOut then
            handleTapEvent(event)
        else
            print("***Touch***")
            playWord(studyLanguage,event.target.text)
        end
    end
end
words={}
wordsFullStudyLangauge={}
wordsFullTargetLangauge={}
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

function everySecondTimer()
    if timerEverySecond then
        timeRemaining=timeRemaining-1
        lblTimeRemaining.text="Time remaining:"..timeRemaining.."" 
        if timeRemaining<=0 then
            print("start paczel")
            hideEverything()
            timer.cancel(timerEverySecond)
            composer.setVariable("numberOfPowerUps",pointCount)
            composer.setVariable("numberOfMonsters",wrongAnswers)
            if wrongAnswers == 0 and pointCount==0 then
                hideEverything()
                composer.gotoScene( "tryAgain" )    
            end
            --handle case where they got some ponts bu no monsters
            if wrongAnswers == 0 and pointCount>0 then
                hideEverything()
                composer.setVariable( "wordsRight", pointCount )
                composer.gotoScene( "goodJob" )    
            end            
            if wrongAnswers > 0  then
                hideEverything()
                if quizMode then
                    composer.setVariable( "wordsRight", pointCount )
                    if pointCount>0 then
                        composer.gotoScene( "goodJob" )
                    else
                        composer.gotoScene( "tryAgain" )
                    end
                else
                    composer.gotoScene( "paczelExplanation" )
                end
            end
        end
    end
end
gameMode=composer.getVariable( "gameMode" )
if gameMode== "Study" then
    print("Study Mode")
    studyMode=true
    quizMode=false
elseif gameMode== "Play" then
    print("Play Mode")
    studyMode=false
    quizMode=false
elseif gameMode== "Quiz" then
    print("Quiz Mode")
    studyMode=false
    quizMode=true
end

if studyMode == false then
    timeRemaining=40
    lblTimeRemaining = display.newText("Time remaining:"..timeRemaining.."", 500, 20, "fonts/ume-tgc5.ttf", 40 )
    lblTimeRemaining:setFillColor( 0, 1, 0 )
    timerEverySecond=timer.performWithDelay( 1000*speed, everySecondTimer, 0 )
end

background = display.newGroup()
wordTable={}
function hideEverything()
    background.isVisible=false
    for key, value in ipairs(wordTable) do
        value.isVisible=false
    end
    if lblTimeRemaining then
        lblTimeRemaining.isVisible=false 
    end
    for key, icon in ipairs(iconsTable) do
        if icon.removeSelf then
            icon:removeSelf()
        end    
    end
end
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
    -- Dump table
    print("dumping json:")
    --print(t[1][1])

    category = composer.getVariable( "category" )
    print("category:"..category)
    studyLanguage = composer.getVariable( "studyLanguage" )
    print("studyLanguage:"..studyLanguage)
    targetLanguage = composer.getVariable( "language" )
    print("targetLanguage:"..targetLanguage)
    words = getWords(studyLanguage,data,category, 8)
    --words = getWords("Romaji",data,"animal", 8)
    wordsFullStudyLangauge=getAllWordsInLanguage(data,studyLanguage)
    wordsFullTargetLangauge=getAllWordsInLanguage(data,targetLanguage)

    --local randomWords = getRandomWords("English",data,"verb", 20)
 
    local randomWords = getRandomWordsFromJsonInLanguageExcluding(studyLanguage, data, category, 20)
    -- Print the words
    print("target words")
    for i, word in ipairs(words) do
        print(i .. ": " .. word)
    end

    print("random words exluding category")
    for i, word in ipairs(randomWords) do
        print(i .. ": " .. word)
    end
    print("end\nrandom words:\n")
    concatenatedTable = concatenateTables(words, randomWords)

    shuffleTable(concatenatedTable)

    for i, word in ipairs(concatenatedTable) do
        print(i .. ": " .. word)
    end
    rowHeight=100
    rowWidth=270
    --draw tiled backgouod

    local cells = {}
    for x = 0.4, 	4 do
        for y = 1, 7 do
            local myRectangle = display.newRect(background, x*rowWidth, y*rowHeight+5, rowWidth, rowHeight )
            myRectangle.strokeWidth = 10
            myRectangle:setFillColor( 0, 0 , 1 )
            myRectangle:setStrokeColor( 0, 1, 0 )
            table.insert(cells,myRectangle)
        end
    end

    local words = display.newGroup()        
    for i = 1, #cells do
        local w = concatenatedTable[i]
        if w then 
            --print(w)
            if string.len(w) > 9 or system.getInfo( "environment" ) == "browser" then
                word = display.newText(words, w, cells[i].x, cells[i].y+5, "fonts/ume-tgc5.ttf", 40 )    
            else
                word = display.newText(words, w, cells[i].x, cells[i].y+5, "fonts/ume-tgc5.ttf", 60 )
		    end
            word:setFillColor( 1, 1, 0 )
		    word:addEventListener( "touch", functTapListener )
            table.insert(wordTable,word)
        end
    end
end
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

rightSoundEffect = audio.loadStream( "audio/right-sound.mp3",system.ResourceDirectory)
wrongSoundEffect = audio.loadStream( "audio/wrong-sound.mp3",system.ResourceDirectory)
--stop music
audio.stop( 1 )

return scene

--DunceCotus> amigojapan, you could also enlarge the click 
--  hitbox to be the whole box
--(done)amigojapan> DunceCotus: I guess in the time I have left I will try adding the extra categories that chatgpt suggested, that I told you the other day
--  2:41 PM <amigojapan> hmm I doubt I can finish that in 1 hour tho,
--  maybe it is better left for tomorrow
--(done)DunceCotus: I managed to squeeze out examples for all hte 
--  categories that ChatGPT gave. tomorrow I will integrate it 
--  into the games dictionary, and I will need to make a way of 
--  browsing thru many categories

--(done)make the character move in hte paczel game
--(kind of done, well, I replaced foods with world dishes)figuure out a way for things that belong to more than one category like fruits or foods to coexist
--(I did not include language names)(kind of done, I asked GPT to give me school subjects that dont include language names(but wont this clash when people actually look for language names? mayeb I shoould not include language names at all))I think(I am sure) languages will clash wish school subjects like spanish
--(fixed,well maybe it woudl be better to flip between righht and wrong words, but think of that later)known bug, when you click twice on a word in game mode, instead of flipping between languages, the word dissapears
--  https://imgur.com/nFG6hLk
--add recorded voices for every word in every langauge
-- maybe store sounds like word-es.was to separate tehm by langauge
--(done)add back to the game area
--(fixed, replaced turkey with Germany, and replaced second Canada with Israel)turkey is both an animal and a country
--	canada seems to be twice in the dictionary
--(almost done, need to detete the tiny icons for monsters an stars)add icons at the top or the screen with how
--  many monsters and how many stars you got
--  in the main game
--create and save scores
--add dictionary mode, rename it to study mode,
--  list all words and click gives pronounciation
--(fixed, the reason was that there were more than 20 animals, and hte dictionary only dipslays the first 20 entries)there was no sound for squirrle and fox in english on web side
--  also no sound for kitsune in Japanese, maybe I somehow failed to record fox in every language?
--(I think I fixed it, but I have not tested it on all platforms yet(cause I am at work))time for touch seems to be <00.3 in simulator and 0.03 in browser
--  the web time does not work for android, will try the simulator time 
-- stars and mosters appear after the end of goof job,need to clear them
--make the quiz only version of the game
--  make the play paczel only part of the game
--bug**Tamama> went back to main screen... then i get a game over popup... i hit OK ... 2 seconds later again the same popup.. it keeps popping