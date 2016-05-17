
-- bone item
minetest.register_craftitem("ethereal:bone", {
	description = "Bone",
	inventory_image = "bone.png",
})

-- bonemeal recipe
minetest.register_craft({
	type = "shapeless",
	output = 'ethereal:bonemeal 3',
	recipe = {'ethereal:bone'},
})

-- add bones to dirt
minetest.override_item("default:dirt", {
	drop = {
		max_items = 1,
		items = {
			{
				items = {'ethereal:bone', 'default:dirt'},
				rarity = 30,
			},
			{
				items = {'default:dirt'},
			}
		}
	},
})

local plants = {
	"flowers:dandelion_white",
	"flowers:dandelion_yellow",
	"flowers:geranium",
	"flowers:rose",
	"flowers:tulip",
	"flowers:viola",
}


local crops = {
	{"farming:cotton_", 8},
	{"farming:wheat_", 8},
	{"farming:tomato_", 8},
	{"farming:corn_", 8},
	{"farming:melon_", 8},
	{"farming:pumpkin_", 8},
	{"farming:beanpole_", 5},
	{"farming:blueberry_", 4},
	{"farming:raspberry_", 4},
	{"farming:carrot_", 8},
	{"farming:cocoa_", 3},
	{"farming:coffee_", 5},
	{"farming:cucumber_", 4},
	{"farming:potato_", 4},
	{"farming:grapes_", 8},
	{"farming:rhubarb_", 3},
	{"ethereal:strawberry_", 8},
	{"ethereal:onion_", 5},
	{"farming:barley_", 7},
}

-- growing routine
local function growth(pointed_thing)

	local pos = pointed_thing.under

	node = minetest.get_node(pos)

	if node.name == ""
	or node.name == "ignore" then
		return
	end

	minetest.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png",
	})

	-- 50/50 chance of growing a sapling
	if minetest.get_item_group(node.name, "sapling") > 0 then

		if math.random(1, 2) == 1 then
			return
		end

		local under =  minetest.get_node({
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		})

		-- specific check for palm tree's, so they grow on sand
		if node.name == "ethereal:palm_sapling"
		and under.name == "default:sand" then
			ethereal.grow_palm_tree(pos)
			return
		end

		-- check for soil under sapling
		if minetest.get_item_group(under.name, "soil") == 0 then
			return
		end

		-- grow ethereal tree
		if node.name == "ethereal:palm_sapling" then
			ethereal.grow_palm_tree(pos)

		elseif node.name == "ethereal:yellow_tree_sapling" then
			ethereal.grow_yellow_tree(pos)

		elseif node.name == "ethereal:big_tree_sapling" then
			ethereal.grow_big_tree(pos)

		elseif node.name == "ethereal:banana_tree_sapling" then
			ethereal.grow_banana_tree(pos)

		elseif node.name == "ethereal:frost_tree_sapling" then
			ethereal.grow_frost_tree(pos)

		elseif node.name == "ethereal:mushroom_sapling" then
			ethereal.grow_mushroom_tree(pos)

		elseif node.name == "ethereal:willow_sapling" then
			ethereal.grow_willow_tree(pos)

		elseif node.name == "ethereal:redwood_sapling" then
			ethereal.grow_redwood_tree(pos)

		elseif node.name == "ethereal:orange_tree_sapling" then
			ethereal.grow_orange_tree(pos)

		elseif node.name == "ethereal:bamboo_sprout" then
			ethereal.grow_bamboo_tree(pos)

		elseif node.name == "ethereal:birch_sapling" then
			ethereal.grow_birch_tree(pos)

		-- grow default tree
		elseif node.name == "default:sapling" then
			default.grow_new_apple_tree(pos)

		elseif node.name == "default:junglesapling" then
			default.grow_new_jungle_tree(pos)

		elseif node.name == "default:pine_sapling" then
			default.grow_new_pine_tree(pos)

		elseif node.name == "default:acacia_sapling" then
			default.grow_new_acacia_tree(pos)

		elseif node.name == "default:aspen_sapling" then
			default.grow_new_aspen_tree(pos)
		end

		return
	end

	local stage = ""

	-- grow registered crops
	for _, row in pairs(crops) do

		if string.find(node.name, row[1]) then

			stage = tonumber( node.name:split("_")[2] )
			stage = math.min(stage + math.random(1, 4), row[2])

			minetest.set_node(pos, {name = row[1] .. stage})

			return

		end

	end

	-- grow grass and flowers
	if minetest.get_item_group(node.name, "soil") > 0 then

		local dirt = minetest.find_nodes_in_area_under_air(
			{x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
			{x = pos.x + 2, y = pos.y + 1, z = pos.z + 2},
			{"group:soil"})

		for _,n in pairs(dirt) do

			local pos2 = n

			pos2.y = pos2.y + 1

			if math.random(0, 5) > 3 then

				minetest.swap_node(pos2,
					{name = plants[math.random(1, #plants)]})
			else

				if node.name == "default:dirt_with_dry_grass" then
					minetest.swap_node(pos2,
						{name = "default:dry_grass_" .. math.random(1, 5)})
				else
					minetest.swap_node(pos2,
						{name = "default:grass_" .. math.random(1, 5)})
				end

			end
		end
	end
end

-- bonemeal item
minetest.register_craftitem("ethereal:bonemeal", {
	description = "Bone Meal",
	inventory_image = "bonemeal.png",

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type == "node" then

			-- Check if node protected
			if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
				return
			end

			if not minetest.setting_getbool("creative_mode") then

				local item = user:get_wielded_item()

				item:take_item()
				user:set_wielded_item(item)
			end

			growth(pointed_thing)

			itemstack:take_item()

			return itemstack
		end
	end,
})