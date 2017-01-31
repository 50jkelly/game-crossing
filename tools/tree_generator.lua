local this = {}

this.run = function(x, y)
	local objects = load_file('data/objects.lua')
	table.insert(objects, {
		name='tree_1_bottom',
		state='default',
		light_map='none',
		light_map_state='none',
		light_mask='none',
		light_mask_state='none',
		x=x,
		y=y,
		width=30,
		height=30,
		speed='none',
		collides=true,
		scene=1,
		layer=2,
		fps='none',
	})
	table.insert(objects, {
		name='tree_1_top',
		state='default',
		light_map='none',
		light_map_state='none',
		light_mask='tree_1_top',
		light_mask_state='default',
		x=x-60,
		y=y-180,
		width=150,
		height=191,
		speed='none',
		collides=false,
		scene=1,
		layer=3,
		fps='none',
	})
	save_file(objects, 'data/objects.lua')
end

return this
