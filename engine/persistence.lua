local plugin = {}

-- Hooks

function plugin.keyPressed()
	local key = data.plugins.keyboard.currentKeyPressed
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

function printTable(table, p)
	local t = table or {}
	local prefix = p or 'data'

	-- If any of the values is a table then we need to initialise the table first

	for i, v in pairs(t) do

		-- Format the index according to its type

		if type(i) == 'string' then
			i = '\''..i..'\''
		end

		if type(v) == 'table' then
			io.write(prefix..'['..i..'] = {}\n')
		end
	end

	-- Start writing the actual values

	for i, v in pairs(t) do

		-- Format the index according to its type

		if type(i) == 'string' then
			i = '\''..i..'\''
		end

		-- Format the value correctly according to its type

		local value = v
		if type(v) == 'string' then
			value = '\''..value..'\''

		elseif type(v) == 'boolean' then 
			if v then
				value = 'true'
			else
				value = 'false'
			end

		elseif type(v) == 'table' then
			value = printTable(v, prefix..'['..i..']')
		end

		-- Finally write the index and value

		if value then io.write(prefix..'['..i..'] = '..value..'\n') end
	end
end

return plugin
