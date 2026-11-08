local stone_def = minetest.registered_nodes["mcl_core:stone"]
local aftermath_def = table.copy(stone_def)
aftermath_def.groups = table.copy(stone_def.groups or {})
aftermath_def.description = "Lava + Water = Stone"
aftermath_def.groups.not_in_creative_inventory = 1
aftermath_def.groups.not_blocking_trains = 1
aftermath_def.on_place = function(itemstack, placer, pointed_thing)
	itemstack:set_name("mcl_core:stone")
	minetest.item_place(itemstack, placer, pointed_thing)
	return itemstack
end

minetest.register_node("lava_and_water:lava_water_aftermath_stone", aftermath_def)

minetest.register_abm({
	label = "Lava and water cooling",
	nodenames = {"mcl_core:lava_source", "mcl_core:lava_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local water_positions = minetest.find_nodes_in_area(
			vector.offset(pos, -1, -1, -1),
			vector.offset(pos, 1, 1, 1),
			"group:water"
		)
		local lava_type = minetest.registered_nodes[node.name].liquidtype

		for _, water_pos in ipairs(water_positions) do
			if water_pos.y < pos.y and water_pos.x == pos.x and water_pos.z == pos.z then
				minetest.set_node(water_pos, {name = "mcl_core:stone"})
				minetest.sound_play("fire_extinguish_flame", {
					pos = water_pos,
					gain = 0.25,
					max_hear_distance = 16,
				}, true)
			elseif lava_type == "flowing" and water_pos.y == pos.y
					and (water_pos.x == pos.x or water_pos.z == pos.z) then
				minetest.set_node(pos, {name = "lava_and_water:lava_water_aftermath_stone"})
				minetest.sound_play("fire_extinguish_flame", {
					pos = pos,
					gain = 0.25,
					max_hear_distance = 16,
				}, true)
			elseif lava_type == "source" and (
					(water_pos.y > pos.y and water_pos.x == pos.x and water_pos.z == pos.z)
					or (water_pos.y == pos.y and (water_pos.x == pos.x or water_pos.z == pos.z))
				) then
				minetest.set_node(pos, {name = "mcl_core:obsidian"})
				minetest.sound_play("fire_extinguish_flame", {
					pos = pos,
					gain = 0.25,
					max_hear_distance = 16,
				}, true)
			elseif lava_type == "flowing" and water_pos.y > pos.y
					and water_pos.x == pos.x and water_pos.z == pos.z then
				minetest.set_node(pos, {name = "lava_and_water:lava_water_aftermath_stone"})
				minetest.sound_play("fire_extinguish_flame", {
					pos = pos,
					gain = 0.25,
					max_hear_distance = 16,
				}, true)
			end
		end
	end,
})

minetest.register_alias("lava_and_water", "lava_and_water:lava_water_aftermath_stone")
minetest.register_alias("lavanwater", "lava_and_water:lava_water_aftermath_stone")
minetest.register_alias("lnw", "lava_and_water:lava_water_aftermath_stone")
