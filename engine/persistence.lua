local this = {}

function this.read(location)
	if love.filesystem.isFile(location) then
		return loadfile(location)()
	end
	return false
end

function this.write(location)
	local contents = 'local data = {}\n' .. this.tostring(data) .. 'return data'
	return love.filesystem.write(location, contents)
end

function this.tostring(table, prefix, contents)

	-- Optional parameters

	prefix = prefix or 'data'
	contents = contents or ''

	-- Nested table declarations

	for index, value in pairs(table) do

		if type(value) == 'table' then
			contents = contents .. prefix ..'['.. format_index(index) ..'] = {}\n'
		end
	end

	-- Writing data

	for index, value in pairs(table) do

		local formatted_value = value

		if type(value) == 'string' then
			formatted_value = "'"..value.."'"

		elseif type(value) == 'boolean' then 
			formatted_value = "'"..tostring(value).."'"

		elseif type(value) == 'table' then
			formatted_value = this.tostring(value, prefix..'['..format_index(index)..']', contents)
		end

		-- Write the formatted value

		if formatted_value and type(value) ~= 'userdata' then
			contents = contents..prefix..'['..format_index(index)..'] = '..formatted_value..'\n'
		end
	end

	return contents
end

local format_index = function(index)
	if type(index) == 'string' then
		return "'"..index.."'"
	end
	return index
end

return this
