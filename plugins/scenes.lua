local this = {}
local scenes = {}
local geometry
local viewport

this.initialise = function()
	geometry = data.libraries.geometry
	scenes['world'] = {}
	current_scene = 'world'
end

this.viewport_updated = function(new_viewport)
	viewport = new_viewport
end

this.change_current_scene = function(scene)
	if scenes[scene] then
		current_scene = scene
	end
end

this.add_to_scene = function(data)
	scenes[data.scene] = scenes[data.scene] or {}
	table.insert(scenes[data.scene], data.entity)
end

this.update = function(dt)
	for _, entity in ipairs(scenes[current_scene]) do
		entity.update(dt)
		
		if geometry.overlapping(viewport, entity) then
			call_hook('plugins', 'render_entity', entity)
		end
	end
end

this.key_down = function(key)
	for _, entity in ipairs(scenes[current_scene]) do
		entity.key_down(key)
	end
end

return this
