M = {}

-- basic trim implementation
M.trim = function(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- split string inputstr by symbol sep
M.split = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- check if table has key
M.has_value = function(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end


return M
