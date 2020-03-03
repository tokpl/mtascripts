function findPlayer(plr,cel)
	local target=nil
	if (tonumber(cel) ~= nil) then
		target=getElementByID("p"..cel)
	else -- podano fragment nicku
		for _,thePlayer in ipairs(getElementsByType("player")) do
			if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 1, true) then
				if (target) then
					outputChatBox("Znaleziono wiecej niz jednego gracza o pasujacym nicku, podaj wiecej liter.", plr)
					return nil
				end
				target=thePlayer
			end
		end
	end
	return target
end

function cmd_kostka(plr,cmd,cel,value)
	if cmd=="wyzwij" then
		if cel and value and tonumber(value) and value>100 then
			if plr.dimension~=1057 and plr.interior~=1 then
				outputChatBox("Żeby kogoś wyzwać, musisz znajdować się w kasynie",plr)
				return
			end
			value=math.floor(value)
			cel=findPlayer(plr,cel)
			if not cel then
				outputChatBox("Nie odnaleziono gracza, którego chcesz wyzwać",plr)
				return
			end
			if cel==plr then
				outputChatBox("Nie możesz wyzwać samego siebie!",plr)
				return
			end
			if cel.getData("sgKostkaWyzwany") and isElement(cel.getData("sgKostkaWyzwany").wyzywajacy) then
				outputChatBox("Gracz już został zaproszony, poczekaj chwilę",plr)
				return
			end
			if value>plr.money then
				outputChatBox("Nie masz wystarczającej ilości pieniędzy",plr)
				return
			end
			outputChatBox(plr.name.." wyzwał Cię na pojedynek w kostkę, o "..value.."$\nMasz 60 sekund na zaakceptowanie wyzwania za pomocą /kostka akceptuj "..plr.name,cel)
			outputChatBox("Wyzwałeś gracza "..cel.name.." na pojedynek o "..value.."$, Gracz ma 60 sekund na zaakceptowanie wyzwania",plr)
			timer=setTimer(function()
				if not cel then
					return
				end
				if cel.getData("sgKostkaWyzwany") then
					cel.removeData("sgKostkaWyzwany")
					if plr then
						outputChatBox("Wyzwanie wygasło",plr)
					end
					outputChatBox("Wyzwanie wygasło",cel)
				end
			end,60*1000,1,cel,plr)
			cel.setData("sgKostkaWyzwany",{tmr=timer,kasa=value,wyzywajacy=plr})
		end
		outputChatBox("Użyj: /wyzwij <login/id> <kwota>",plr)
		outputChatBox("Kwota musi być większa od 100$",plr)
	elseif cmd=="akceptuj" then
		if not cel then
			outputChatBox("Użyj: /akceptuj <login/id>",plr)
			return
		end
		if not plr.getData("sgKostkaWyzwany") then
			outputChatBox("Nikt Ciebie nie zaprosił do kostki, bądź zaproszenie wygasło",plr)
			return
		end
		cel=findPlayer(plr,cel)
		if not cel then
			outputChatBox("Nie odnaleziono gracza, którego chcesz wyzwać",plr)
			return
		end
		if cel~=plr.getData("sgKostkaWyzwany").wyzywajacy then
			outputChatBox(cel.name.." nie zaprosił Ciebie do kostki",plr)
			return
		end
		if plr.dimension~=1057 and plr.interior~=1 then
			outputChatBox("Żeby zaakceptować wyzwanie, musisz znajdować się w kasynie",plr)
			return
		end
		if cel.dimension~=1057 and cel.interior~=1 then
			outputChatBox(cel.name.." nie znajduje się w kasynie",cel)
			return
		end
		if plr.getData("sgKostkaWyzwany").kasa>cel.money then
			outputChatBox(cel.name.." nie ma pieniędzy na rozgrywkę!",cel)
			return
		end
		if plr.getData("sgKostkaWyzwany").kasa>plr.money then
			outputChatBox("Nie masz wystarczającej ilości pieniędzy na rozgrywkę!",plr)
			return
		end
		plr:takeMoney(plr.getData("sgKostkaWyzwany").kasa)
		cel:takeMoney(plr.getData("sgKostkaWyzwany").kasa)
		pk=math.random(1,6)
		ck=math.random(1,6) 
		if pk==ck then
			outputChatBox("REMIS, we dwójkę wylosowaliście "..pk.." oczek na kostce!",plr)
			outputChatBox("REMIS, we dwójkę wylosowaliście "..pk.." oczek na kostce!",cel)
		elseif pk>ck then
			cel:takeMoney(plr.getData("sgKostkaWyzwany").kasa)
			plr:giveMoney(plr.getData("sgKostkaWyzwany").kasa)
			outputChatBox(plr.name.." wylosował liczbę "..pk..", "..cel.name.." wylosował liczbę "..ck..", Zwycięża: "..plr.name,plr)
			outputChatBox(plr.name.." wylosował liczbę "..pk..", "..cel.name.." wylosował liczbę "..ck..", Zwycięża: "..plr.name,cel)
		elseif ck>pk then
			cel:giveMoney(plr.getData("sgKostkaWyzwany").kasa)
			plr:takeMoney(plr.getData("sgKostkaWyzwany").kasa)
			outputChatBox(cel.name.." wylosował liczbę "..pk..", "..plr.name.." wylosował liczbę "..ck..", Zwycięża: "..cel.name,plr)
			outputChatBox(cel.name.." wylosował liczbę "..pk..", "..plr.name.." wylosował liczbę "..ck..", Zwycięża: "..cel.name,cel)
		end
		killTimer(plr.getData("sgKostkaWyzwany").tmr)
		plr.removeData("sgKostkaWyzwany")
	end
end
addCommandHandler("wyzwij",cmd_kostka)
addCommandHandler("akceptuj",cmd_kostka)
