local staticEntities = {}
local staticEntitiesTable = {}
local staticEntitiesCount = 1

function staticEntities.saveGame()
	local saveLoad = data.plugins.saveLoad
	for index, entity in ipairs(staticEntitiesTable) do
		local file = saveLoad.saveFilePath .. 'staticEntity' .. index .. '.txt'
		saveLoad.writeTable(entity, file)
	end
end

function staticEntities.loadGame()
	staticEntitiesTable = {}
	local saveLoad = data.plugins.saveLoad
	local i = 1
	while true do
		local file = saveLoad.saveFilePath .. 'staticEntity' .. i .. '.txt'
		local entity = saveLoad.readTable({}, file)
		if entity then
			table.insert(staticEntitiesTable, entity)
			i = i + 1
		else
			break
		end
	end
	staticEntitiesCount = table.getn(staticEntitiesTable)
end

function staticEntities.getTable()
	return staticEntitiesTable
end

function staticEntities.add(entity)
	table.insert(staticEntitiesTable, entity)
end

function staticEntities.remove(id)
	local found = nil
	for index, entity in ipairs(staticEntitiesTable) do
		if entity.id == id then
			found = index
			break
		end
	end
	if found then
		table.remove(staticEntitiesTable, found)
	end
end

function staticEntities.getEntity(id)
	for _, entity in ipairs(staticEntitiesTable) do
		if entity.id == id then
			return entity
		end
	end
	return nil
end

return staticEntities
