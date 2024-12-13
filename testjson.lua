local json = require( "json" )

function dumpTable(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
 
-- Path for the file to read
local path = system.pathForFile( filename, loc )
 
-- Open the file handle
local file, errorString = io.open( path, "r" )

if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Read data from file
    local contents = file:read( "*a" )
    -- Decode JSON data into Lua table
    local t = json.decode( contents )
    -- Close the file handle
    io.close( file )
    -- Dump table
    print("dumping json:")
    dumpTable(t)
end