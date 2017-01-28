local shaders = {}
shaders.ambientLight = require 'shaders.ambientLight'
shaders.dynamicLight = require 'shaders.dynamicLight'

-- Hooks

function shaders.preDraw()
	for name, shader in pairs(shaders) do
		if name ~= 'preDraw' then
			shader.preDraw()
		end
	end
end

return shaders
