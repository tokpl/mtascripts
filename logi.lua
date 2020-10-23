

-- globalne logi
local global={
	{name="other",hook=""}, -- musi byc pierwsze
	{name="global",hook=""},
	{name="debug",hook=""},
	{name="chat",hook=""},
	{name="administracyjne",hook=""},
}

for i,v in ipairs(global) do
	time=getRealTime()
	year=time.year+1900
	month=time.month+1
	if (month<10) then
		month=tostring("0"..month)
	end
	v.file=fileCreate("logi/"..v.name.."/"..year.."-"..month.."-"..time.monthday.."-"..time.hour.."-"..time.minute.."-"..time.second..".skyGaming")
end

function loguj(file,message)
	for i,v in ipairs(global) do
		if v.name==file then
			state=v
		end
	end
	if not state then
		state=global[1]
	end
	time=getRealTime()
	year=time.year+1900
	month=time.month+1
	if (month<10) then
		month=tostring("0"..month)
	end
	message=tostring(year.."-"..month.."-"..time.monthday..":"..time.hour..":"..time.minute..":"..time.second.." : "..message.."\n")
	fileWrite(state.file, message)
	fileFlush(state.file)

	if not state.hook or #state.hook<10 then
		return
	end
	sendOptions={
		queueName = "dcq",
		connectionAttemps = 3,
		connectTimeout = 5000,
		formFields ={
			content="```"..message.."```"
		}
	}
	fetchRemote(state.hook, sendOptions, function() end)
end

addEventHandler( "onResourceStop", resourceRoot,
    function( resource )
        for i,v in ipairs(global) do
        	fileFlush(v.file)
        	fileClose(v.file)
        end
   end
)


addEventHandler("onDebugMessage", getRootElement(), function(message, level, file, line)

	if level == 1 then
		loguj("debug","ERROR: " .. file .. ":" .. tostring(line) .. ", " .. message)
	elseif level == 2 then
		loguj("debug","WARNING: " .. file .. ":" .. tostring(line) .. ", " .. message)
	else
		loguj("debug","INFO: " .. file .. ":" .. tostring(line) .. ", " .. message)
	end

end)
