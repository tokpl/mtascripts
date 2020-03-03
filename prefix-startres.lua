for k,v in ipairs ( getResources() ) do
	if string.find(getResourceName(v),"COS") then
		startResource(v)
	end
end
