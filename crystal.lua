
local S = ethereal.translate


-- Crystal Spike (Hurts if you touch it)
minetest.register_node("ethereal:crystal_spike", {
	description = S("Crystal Spike"),
	drawtype = "plantlike",
	tiles = {"ethereal_crystal_spike.png"},
	inventory_image = "ethereal_crystal_spike.png",
	wield_image = "ethereal_crystal_spike.png",
	paramtype = "light",
	light_source = 7,
	sunlight_propagates = true,
	walkable = true,
	damage_per_second = 1,
	groups = {cracky = 1, falling_node = 1, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed", fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 0, 5 / 16}
	},
	node_box = {
		type = "fixed", fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 0, 5 / 16}
	}
})


-- Crystal Ingot
minetest.register_craftitem("ethereal:crystal_ingot", {
	description = S("Crystal Ingot"),
	inventory_image = "ethereal_crystal_ingot.png",
	wield_image = "ethereal_crystal_ingot.png"
})

-- Check for builtin_item mod and add custom drop code to crystal spikes
if minetest.get_modpath("builtin_item") then

	minetest.override_item("ethereal:crystal_spike", {

		dropped_step = function(self, pos, dtime)

			self.ctimer = (self.ctimer or 0) + dtime
			if self.ctimer < 5.0 then return end
			self.ctimer = 0

			if self.node_inside
			and self.node_inside.name ~= "default:water_source" then
				return
			end

			local objs = minetest.get_objects_inside_radius(pos, 0.8)

			if not objs or #objs ~= 2 then return end

			local crystal, mese, ent = nil, nil, nil

			for k, obj in pairs(objs) do

				ent = obj:get_luaentity()

				if ent and ent.name == "__builtin:item" then

					if ent.itemstring == "default:mese_crystal 2"
					and not mese then

						mese = obj

					elseif ent.itemstring == "ethereal:crystal_spike 2"
					and not crystal then

						crystal = obj
					end
				end
			end

			if mese and crystal then

				mese:remove()
				crystal:remove()

				minetest.add_item(pos, "ethereal:crystal_ingot")

				return false
			end
		end
	})
end

minetest.register_craft({
	output = "ethereal:crystal_ingot",
	recipe = {
		{"default:mese_crystal", "ethereal:crystal_spike"},
		{"ethereal:crystal_spike", "default:mese_crystal"},
		{"bucket:bucket_water", ""}
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})


-- Crystal Block
minetest.register_node("ethereal:crystal_block", {
	description = S("Crystal Block"),
	tiles = {"ethereal_crystal_block.png"},
	light_source = 9,
	is_ground_content = false,
	groups = {cracky = 1, level = 2, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_craft({
	output = "ethereal:crystal_block",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"}
	}
})

minetest.register_craft({
	output = "ethereal:crystal_ingot 9",
	recipe = {{"ethereal:crystal_block"}}
})


-- Crystal Sword (Powerful wee beastie)
minetest.register_tool("ethereal:sword_crystal", {
	description = S("Crystal Sword"),
	inventory_image = "ethereal_crystal_sword.png",
	wield_image = "ethereal_crystal_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {[1] = 1.70, [2] = 0.70, [3] = 0.25},
				uses = 50,
				maxlevel = 3
			}
		},
		damage_groups = {fleshy = 10}
	},
	groups = {sword = 1},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "ethereal:sword_crystal",
	recipe = {
		{"ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot"},
		{"default:steel_ingot"}
	}
})


-- Crystal Axe
minetest.register_tool("ethereal:axe_crystal", {
	description = S("Crystal Axe"),
	inventory_image = "ethereal_crystal_axe.png",
	wield_image = "ethereal_crystal_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.00, [2] = 0.80, [3] = 0.40},
				uses = 40,
				maxlevel = 3
			}
		},
		damage_groups = {fleshy = 7}
	},
	groups = {axe = 1},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "ethereal:axe_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "default:steel_ingot"},
		{"", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "ethereal:axe_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"default:steel_ingot", "ethereal:crystal_ingot"},
		{"default:steel_ingot", ""}
	}
})


-- Crystal Pick (This will last a while)
minetest.register_tool("ethereal:pick_crystal", {
	description = S("Crystal Pickaxe"),
	inventory_image = "ethereal_crystal_pick.png",
	wield_image = "ethereal_crystal_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 3,
		groupcaps={
			cracky = {
				times = {[1] = 1.8, [2] = 0.8, [3] = 0.40},
				uses = 40,
				maxlevel = 3
			}
		},
		damage_groups = {fleshy = 6}
	},
	groups = {pickaxe = 1},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "ethereal:pick_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"", "default:steel_ingot", ""},
		{"", "default:steel_ingot", ""}
	}
})

local function string_starts(string,start)
	return string.sub(string,1,string.len(start))==start
 end
-- dig override for crystal's silk touch ability
local old_handle_node_drops = minetest.handle_node_drops

local tools ={
	["ethereal:shovel_crystal"]=true,
	["ethereal:pick_crystal"]=true,
	["ethereal:axe_crystal"]=true,
	["ethereal:sword_crystal"]=true,
	["ethereal:multitool_crystal"]=true,
}
function minetest.handle_node_drops(pos, drops, digger)

	-- are we holding crystal stuff?
	local item_name=digger:get_wielded_item():get_name()
	if not digger or not tools[item_name] then
		return old_handle_node_drops(pos, drops, digger)
	end

	local nn = minetest.get_node(pos).name

	if minetest.get_item_group(nn,"not_in_creative_inventory") == 1
	or minetest.get_item_group(nn, "no_silktouch") == 1 then
		return old_handle_node_drops(pos, drops, digger)
	end
	
	if minetest.get_item_group(nn, "soil") == 0
	and not (
		string_starts(nn,"default:")
		or string_starts(nn,"ethereal:")
		or string_starts(nn,"moreores:")
		or string_starts(nn,"technic:mineral")
	)
	then
		return old_handle_node_drops(pos, drops, digger)
	end

	return old_handle_node_drops(pos, {ItemStack(nn)}, digger)
end

-- re-register the crystal multitool under a different name
-- this is because the original behaviour is problematic (allows silk touching of nodes you don't really want players obtaining...)
if multitools then
	minetest.unregister_item("multitools:multitool_crystal")

	multitools.register_multitool("ethereal", "crystal", S("Crystal Multitool"), "multitool_crystal.png", 8.0,{
		full_punch_interval = 0.9,
		max_drop_level = 3,
		groupcaps = {
		cracky = {times={[1]=1.8, [2]=0.8, [3]=0.40}, uses=20, maxlevel=3},
		crumbly = {times={[1]=0.70, [2]=0.35, [3]=0.20}, uses=50, maxlevel=2},
		choppy = {times={[1]=1.75, [2]=0.45, [3]=0.45}, uses=50, maxlevel=2},
		snappy = {times={[1]=1.70, [2]=0.70, [3]=0.25}, uses=50, maxlevel=3},
		},
		damage_groups = {fleshy=10},
	},
	{breaks = "default_tool_breaks"}
	)
end

minetest.register_tool("ethereal:shovel_crystal", {
	description = S("Crystal Shovel"),
	inventory_image = "ethereal_crystal_shovel.png",
	wield_image = "ethereal_crystal_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {
				times = {[1] = 1.10, [2] = 0.50, [3] = 0.30},
				uses = 30,
				maxlevel = 3
			}
		},
		damage_groups = {fleshy = 4}
	},
	groups = {shovel = 1},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "ethereal:shovel_crystal",
	recipe = {
		{"ethereal:crystal_ingot"},
		{"default:steel_ingot"},
		{"default:steel_ingot"}
	}
})


-- Crystal Gilly Staff (replenishes air supply when used)
minetest.register_tool("ethereal:crystal_gilly_staff", {
	description = S("Crystal Gilly Staff"),
	inventory_image = "ethereal_crystal_gilly_staff.png",
	wield_image = "ethereal_crystal_gilly_staff.png",

	on_use = function(itemstack, user, pointed_thing)

		if user:get_breath() < 10 then
			user:set_breath(10)
		end
	end
})

minetest.register_craft({
	output = "ethereal:crystal_gilly_staff",
	recipe = {
		{"ethereal:green_moss", "ethereal:gray_moss", "ethereal:fiery_moss"},
		{"ethereal:crystal_moss", "ethereal:crystal_ingot", "ethereal:mushroom_moss"},
		{"", "ethereal:crystal_ingot", ""}
	},
})


-- Add [toolranks] mod support if found
if minetest.get_modpath("toolranks") then

	-- Helper function
	local function add_tool(name, desc, afteruse)

		minetest.override_item(name, {
			original_description = desc,
			description = toolranks.create_description(desc, 0, 1),
			after_use = afteruse and toolranks.new_afteruse
		})
	end

	add_tool("ethereal:pick_crystal", "Crystal Pickaxe", true)
	add_tool("ethereal:axe_crystal", "Crystal Axe", true)
	add_tool("ethereal:shovel_crystal", "Crystal Shovel", true)
	add_tool("ethereal:sword_crystal", "Crystal Sword", true)
end
