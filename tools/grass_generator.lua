local this = {}
this.run = function()
	local serpent = require 'libraries.serpent'
	local file = io.open('data/objects.lua', 'r')
	io.input(file)
	local objects = loadstring(io.read('*all'))()
	local start_x, start_y, end_x, end_y = -5000, -5000, 5000, 5000
	local step_x, step_y = 320, 320

	for x = start_x, end_x, step_x do
		for y = start_y, end_y, step_y do
			table.insert(objects, {
				name='grass',
				state='default',
				light_map='none',
				light_map_state='none',
				light_mask='none',
				light_mask_state='none',
				x=x,
				y=y,
				width=step_x,
				height=step_y,
				speed='none',
				collides=false,
				scene=1,
				layer=1,
				fps='none',
			})
		end
	end
	io.close(file)

	file = io.open('data/objects.lua', 'w')
	io.output(file)
	io.write(serpent.block(objects, {name='objects'}))
	io.close(file)
end
return this
