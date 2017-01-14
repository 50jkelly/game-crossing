local plugin = {}

-- Hooks

function plugin.keyPressed()
	local key = data.plugins.controls.currentKeyPressed
	if key == 'saveGame' then
		callHook('plugins', 'saveGame')
	end
	if key == 'loadGame' then
		callHook('plugins', 'loadGame')
	end
end

function plugin.read(location)
	local file = io.open(location, 'r')
	if not file then return end
	io.input(file)
	local contents = io.read('*all')
	io.close(file)
	return loadstring(contents)()
end

function plugin.write(t, location)
	local file = io.open(location, 'w')
	io.output(file)
	io.write('local data = {}\n')
	io.write(printTable(t))
	io.write('return data')
	io.close(file)
end

-- Functions

function printTable(t, p)
	local prefix = p or 'data'
	for i, v in pairs(t) do
		if type(v) == 'table' then io.write(prefix..'[\''..i..'\'] = {}\n') end
	end
	for i, v in pairs(t) do
		local value = v
		if type(v) == 'string' then value = '\''..value..'\'' end
		if type(v) == 'boolean' then 
			if v then value = 'true' else value = 'false' end
		end
		if type(v) == 'table' then value = printTable(v, prefix..'[\''..i..'\']') end
		if value then io.write(prefix..'[\''..i..'\'] = '..value..'\n') end
	end
end

return plugin
