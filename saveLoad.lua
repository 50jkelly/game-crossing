local saveLoad = {}

function saveLoad.initialise()
	saveLoad.saveFilePath = 'saves/'
end

function saveLoad.keyPressed()
	local key = data.plugins.controls.currentKeyPressed
	if key == 'saveGame' then
		callHook('plugins', 'saveGame')
	end
	if key == 'loadGame' then
		callHook('plugins', 'loadGame')
	end
end

function saveLoad.fileExists(file)
	local file = io.open(file, 'rb')
	if file then file:close() end
	return file ~= nil
end

function saveLoad.writeTable(table, file)
	f = io.open(file, 'w')
	io.output(f)
	for index, value in pairs(table) do
		local noWrite =
			type(value) == 'table' or
			type(value) == 'function' or
			index == 'sprite' or
			index == 'cursor'

		if noWrite == false then
			io.write(index..', '..tostring(value)..'\n')
		end
	end
	io.close(f)
end

function saveLoad.readTable(table, file)
	if not saveLoad.fileExists(file) then return table end
	for line in io.lines(file) do
		local index, value = string.match(line, '(%w+), ([%w%d_]+)')

		if index then
			if string.match(value, '^[%d.]+$') then
				value = tonumber(value)
			end

			if string.match(value, 'true') then
				value = true
			elseif string.match(value, 'false') then
				value = false
			end

			table[index] = value
		end
	end
	return table
end

function saveLoad.readArray(array, file)
	if not saveLoad.fileExists(file) then return array end
	for line in io.lines(file) do
		local index, value = string.match(line, '(%w+), ([%w%d_]+)')

		if index then
			if string.match(value, '^[%d.]+$') then
				value = tonumber(value)
			end

			if string.match(value, 'true') then
				value = true
			elseif string.match(value, 'false') then
				value = false
			end

			array[tonumber(index)] = value
		end
	end
	return array
end

return saveLoad
