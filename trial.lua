function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
 end

 function lines_from(file)
    local lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
  end

function trialAlgorythm()
    --path = "trialFile.txt"--system.pathForFile( "trialFile.txt", system.DocumentsDirectory)
    if system.getInfo("platform")=="android" then
        path = system.pathForFile( "trialFileLanguageHero.txt", system.DocumentsDirectory)
        print(path)
        if file_exists(path) then
            lines= lines_from(path)
            lineone=lines[1]
            local threeDaysInSeconds=259200--259200 is 3 days in seconds
            local trialStartTime=tonumber(lineone)
            
            local currentDateTime = os.time()
            local difference = os.difftime(currentDateTime, trialStartTime)
            if difference > threeDaysInSeconds then
                return "Trial period over"
            else
                return "Trial period valid"
            end
        else
            local currentDateTime = os.time()
            local trialStartTime=tostring(currentDateTime)
            print("trial start:" .. trialStartTime)
            file = io.open(path, "a+")
            file:write(trialStartTime)
            file:close()
            return "Trial period start"
        end
    else
        return "Free version"
    end
end
--for testing it 
--print(trialAlgorythm())