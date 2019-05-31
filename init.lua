local add_3dx2 = function(a,b)
	return {x=a.x+b.x,y=a.y+b.y,z=a.z+b.z}
end

local mul_3dx2 = function(a,b)
	return {x=a.x*b.x,y=a.y*b.y,z=a.z*b.z}
end

local activate = function(player_name, material)
	local has, missing = minetest.check_player_privs(player_name, {interact = true})
	if not has then
	    return
	end
	local player = minetest.get_player_by_name(player_name)
	local inv = player:get_inventory()
	local stack = inv:get_stack("main", 0)
	local material = material or (stack:is_known() and stack:get_name())
	if not material then
		return
	end
	local x = stack:get_count()
	local y = inv:get_stack("main", 1):get_count()
	local z = inv:get_stack("main", 2):get_count()
	local yaw = player:get_look_horizontal()
	local dir = {x=math.sin(yaw), y=0, z=math.cos(yaw)}
	local start = add_3dx2(player:get_pos(), dir)
	dir.y = 1
	for ix = 0, x-1 do
		for iy = 0, y-1 do
			for iz = 0, z-1 do
				local pos = add_3dx2(start, mul_3dx2(dir, {x=ix, y=iy, z=iz}))
				if not replacer_homedecor_node_is_owned(pos, player) then
					minetest.set_node(pos, {name = node_type})
				end
			end
		end
	end
end

minetest.register_tool("multiplacer:multiplacer", {
	description = "Placer Tool",
	inventory_image = "multiplacer:multiplacer.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40},
				uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=1},
	},
	on_use = function(itemstack, user, pointed_thing)
		activate(user:get_player_name(), nil)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		activate(placer:get_player_name(), "air")
	end
})