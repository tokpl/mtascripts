

-- globalne logi
local global={
	{name="other",hook="https://discordapp.com/api/webhooks/678612294866960386/OjgdrlUemFVqVxRoi3PzxorNx5HN-NS7rWNL4xiJO1AH6MOLiBkqh3FDZyzaXh_l0VET"}, -- musi byc 1
	{name="global",hook="https://discordapp.com/api/webhooks/678612706432909362/8m_q36IY4N-z3nZXQ1wYV9Ktfm1FjmkaK0F9loj79-inx-K0zykSN7QBR8O8PwH0HBZX"},
	{name="debug",hook="https://discordapp.com/api/webhooks/678609159981236244/nDv8pdSb9n8xBPfQcwYw1zBi15tro-HCWq9pM_rScq9d6e_gVFYJmdU1MdWx5HeilUoZ"},
	{name="chat",hook="https://discordapp.com/api/webhooks/678611213676183572/1l_RdUNELZSlfL7_5x9g9eIK2NcphxiO3iHgB3rtLd9yofpXUgYt5yU6fbgIx1v_812F"},
	{name="administracyjne",hook="https://discordapp.com/api/webhooks/678611625992781843/G_fY0c-khfipXQ5FxCT5QTsNB-vA2XMQIixbLMYxbI1PQpZKnYqtTCxZoUPPK0-wIW-b"},
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

	if not state.hook then
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