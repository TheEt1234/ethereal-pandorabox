-- https://github.com/pandorabox-io/planet_mars/blob/20f7465eb56ab025f29a24a8407247a0ff9aa1d2/vacuum.lua
local has_vacuum_mod = minetest.get_modpath("vacuum")

local y_start = ethereal.Y_min
local y_height = ethereal.Y_max


if has_vacuum_mod then

	local old_is_pos_in_space = vacuum.is_pos_in_space
	vacuum.is_pos_in_space = function(pos)

		if pos.y > y_start and pos.y < y_height then
            return false
		end
        return old_is_pos_in_space(pos)
	end


end