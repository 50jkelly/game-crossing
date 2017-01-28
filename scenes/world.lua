local this = {}
local entities = {}
local geometry
local viewport

this.initialise = function()
	geometry = data.libraries.geometry
	this.x = -3200
	this.y = -3200
	this.width = 6400
	this.height = 6400

	for x = this.x, this.x + this.width, 320 do
		for y = this.y, this.y + this.height, 320 do
			table.insert(entities, {
				x = x,
				y = y,
				width = 320,
				height = 320,
				layer = 1,
				sprite = 'grass'
			})
		end
	end
end

this.update = function(dt)
	for _, entity in ipairs(entities) do
		if entity.update then
			entity.update(dt)
		end
		
		if viewport and geometry.overlapping(viewport, entity) then
			call_hook('plugins', 'render_entity', entity)
		end
	end
end

this.viewport_updated = function(new_viewport)
	viewport = new_viewport
end

this.key_down = function(key)
	for _, entity in ipairs(entities) do
		if entity.key_down then
			entity.key_down(key)
		end
	end
end

this.add_entity = function(entity)
	table.insert(entities, entity)
end

return this
