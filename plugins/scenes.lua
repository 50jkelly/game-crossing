local this = {}
local current_scene

local scenes = {
	world = require 'scenes.world',
}

local call_scene_hook = function(name, data)
	if current_scene and scenes[current_scene][name] then
		scenes[current_scene][name](data)
	end
end

this.initialise = function()
	current_scene = 'world'

	for _, scene in pairs(scenes) do
		if scene.initialise then
			scene.initialise()
		end
	end
end

this.change_current_scene = function(scene)
	if scenes[scene] then
		current_scene = scene
	end
end

this.add_to_scene = function(data)
	if scenes[data.scene] then
		scenes[data.scene].add_entity(data.entity)
	end
end

this.update = function(dt)
	call_scene_hook('update', dt)
end

this.key_down = function(key)
	call_scene_hook('key_down', key)
end

this.viewport_updated = function(new_viewport)
	call_scene_hook('viewport_updated', new_viewport)
end

return this
