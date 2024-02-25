-- Makes default biomes not able to be generated in floatlands
-- code obviously copied from biomes_init.lua

local old_biomes = {}

-- backup registered biome data
for key, def in pairs(minetest.registered_biomes) do
	old_biomes[key] = def
end

minetest.clear_registered_biomes()

-- create list of default biomes to remove
local def_biomes = {
	["rainforest_swamp"] = 1,
	["grassland_dunes"] = 1,
	["cold_desert"] = 1,
	["taiga"] = 1,
	["icesheet_ocean"] = 1,
	["snowy_grassland_under"] = 1,
	["desert"] = 1,
	["deciduous_forest"] = 1,
	["taiga_ocean"] = 1,
	["desert_ocean"] = 1,
	["tundra_ocean"] = 1,
	["snowy_grassland_ocean"] = 1,
	["sandstone_desert"] = 1,
	["tundra_under"] = 1,
	["coniferous_forest_ocean"] = 1,
	["tundra"] = 1,
	["sandstone_desert_under"] = 1,
	["grassland"] = 1,
	["rainforest"] = 1,
	["grassland_ocean"] = 1,
	["tundra_beach"] = 1,
	["rainforest_under"] = 1,
	["savanna_under"] = 1,
	["icesheet"] = 1,
	["savanna_ocean"] = 1,
	["tundra_highland"] = 1,
	["savanna"] = 1,
	["cold_desert_under"] = 1,
	["cold_desert_ocean"] = 1,
	["desert_under"] = 1,
	["taiga_under"] = 1,
	["savanna_shore"] = 1,
	["sandstone_desert_ocean"] = 1,
	["snowy_grassland"] = 1,
	["coniferous_forest_under"] = 1,
	["deciduous_forest_ocean"] = 1,
	["grassland_under"] = 1,
	["icesheet_under"] = 1,
	["rainforest_ocean"] = 1,
	["deciduous_forest_shore"] = 1,
	["deciduous_forest_under"] = 1,
	["coniferous_forest_dunes"] = 1,
	["coniferous_forest"] = 1,
-- biomes added by me
	["mountain"]=1,
	["default"]=1,
}


-- only re-register biomes that aren't on the list
for key, def in pairs(old_biomes) do

	if not def_biomes[key] then
		minetest.register_biome(def)
    else 
        def.y_max=ethereal.default_y_max
        minetest.register_biome(def)
    end
end