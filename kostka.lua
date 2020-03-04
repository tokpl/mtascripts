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
		if cel and value and tonumber(value) and tonumber(value)>=100 then
			if getElementDimension(plr)~=1057 and getElementInterior(plr)~=1 then
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
			if getElementData(cel,"sgKostkaWyzwany") and isElement(getElementData(cel,"sgKostkaWyzwany").wyzywajacy) then
				outputChatBox("Gracz już został zaproszony, poczekaj chwilę",plr)
				return
			end
			if value>getPlayerMoney(plr) then
				outputChatBox("Nie masz wystarczającej ilości pieniędzy",plr)
				return
			end
			outputChatBox(getPlayerName(plr).." wyzwał Cię na pojedynek w kostkę, o "..value.."$\nMasz 60 sekund na zaakceptowanie wyzwania za pomocą /akceptuj "..getPlayerName(plr),cel)
			outputChatBox("Wyzwałeś gracza "..getPlayerName(cel).." na pojedynek o "..value.."$, Gracz ma 60 sekund na zaakceptowanie wyzwania",plr)
			timer=setTimer(function(cel)
				if not cel then
					return
				end
				if getElementData(cel,"sgKostkaWyzwany") then
					removePlayerData(cel,"sgKostkaWyzwany")
					if plr then
						outputChatBox("Wyzwanie wygasło",plr)
					end
					outputChatBox("Wyzwanie wygasło",cel)
				end
			end,60*1000,1,cel,plr)
			setElementData(cel,"sgKostkaWyzwany",{tmr=timer,kasa=value,wyzywajacy=plr})
			return
		end
		outputChatBox("Użyj: /wyzwij <login/id> <kwota>",plr)
		outputChatBox("Kwota musi być większa od 100$",plr)
	elseif cmd=="akceptuj" then
		if not cel then
			outputChatBox("Użyj: /akceptuj <login/id>",plr)
			return
		end
		if not getElementData(plr,"sgKostkaWyzwany") then
			outputChatBox("Nikt Ciebie nie zaprosił do kostki, bądź zaproszenie wygasło",plr)
			return
		end
		cel=findPlayer(plr,cel)
		if not cel then
			outputChatBox("Nie odnaleziono gracza, którego chcesz wyzwać",plr)
			return
		end
		if cel~=getElementData(plr,"sgKostkaWyzwany").wyzywajacy then
			outputChatBox(cel.name.." nie zaprosił Ciebie do kostki",plr)
			return
		end
		if getElementDimension(plr)~=1057 and getElementInterior(plr)~=1 then
			outputChatBox("Żeby zaakceptować wyzwanie, musisz znajdować się w kasynie",plr)
			return
		end
		if getElementDimension(cel)~=1057 and getElementInterior(cel)~=1 then
			outputChatBox(cel.name.." nie znajduje się w kasynie",cel)
			return
		end
		if getElementData(plr,"sgKostkaWyzwany").kasa>getPlayerMoney(cel) then
			outputChatBox(cel.name.." nie ma pieniędzy na rozgrywkę!",cel)
			return
		end
		if getElementData(plr,"sgKostkaWyzwany").kasa>getPlayerMoney(plr) then
			outputChatBox("Nie masz wystarczającej ilości pieniędzy na rozgrywkę!",plr)
			return
		end
		pk=math.random(1,6)
		ck=math.random(1,6) 
		if pk==ck then
			outputChatBox("REMIS, we dwójkę wylosowaliście "..pk.." oczek na kostce!",plr)
			outputChatBox("REMIS, we dwójkę wylosowaliście "..pk.." oczek na kostce!",cel)
		elseif pk>ck then
			takePlayerMoney(cel,getElementData(plr,"sgKostkaWyzwany").kasa)
			givePlayerMoney(plr,getElementData(plr,"sgKostkaWyzwany").kasa)
			outputChatBox(getPlayerName(plr).." wylosował liczbę "..pk..", "..getPlayerName(cel).." wylosował liczbę "..ck..", Zwycięża: "..getPlayerName(plr),plr)
			outputChatBox(getPlayerName(plr).." wylosował liczbę "..pk..", "..getPlayerName(cel).." wylosował liczbę "..ck..", Zwycięża: "..getPlayerName(plr),cel)
		elseif ck>pk then
			givePlayerMoney(cel,getElementData(plr,"sgKostkaWyzwany").kasa)
			takePlayerMoney(plr,getElementData(plr,"sgKostkaWyzwany").kasa)
			outputChatBox(getPlayerName(cel).." wylosował liczbę "..pk..", "..getPlayerName(plr).." wylosował liczbę "..ck..", Zwycięża: "..getPlayerName(cel),plr)
			outputChatBox(getPlayerName(cel).." wylosował liczbę "..pk..", "..getPlayerName(plr).." wylosował liczbę "..ck..", Zwycięża: "..getPlayerName(cel),cel)
		end
		killTimer(getElementData(plr,"sgKostkaWyzwany").tmr)
		removeElementData(plr,"sgKostkaWyzwany")
	end
end
addCommandHandler("wyzwij",cmd_kostka)
addCommandHandler("akceptuj",cmd_kostka)

for i,v in ipairs(getElementsByType("player")) do
	if not getElementData(v,"sgKostkaWyzwany") then
		return
	end
	removeElementData(v,"sgKostkaWyzwany")
end
