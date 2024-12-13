local clock = os.clock
function sleep(time)
	startTime=clock()
	print("startTime:"..startTime)
	endTime=startTime+time
	print("endTime:"..endTime)
	repeat
	   startTime=clock()
	until( startTime>=endTime )
end

--usage
--[[
	print("sleep 2 seconds")
	sleep(2)
	print("end")
]]
