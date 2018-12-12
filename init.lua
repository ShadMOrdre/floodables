floodables = {
  { group = "torch", drop = "default:torch", sound = "floodables_torch", gain = 0.8 },
  { group = "flora", sound = "floodables_grass", gain = 0.2 },
  { group = "wheat", drop = "farming:seed_wheat", sound = "floodables_grass", gain = 0.2 },
  { name = "default:junglegrass", sound = "floodables_grass", gain = 0.2 },
  { group = "grass", drop = "default:grass_1", sound = "floodables_grass", gain = 0.2 },
  { group = "dry_grass", drop = "default:dry_grass_1", sound = "floodables_grass", gain = 0.2 },
--  { name = "default:dirt_with_grass", erode = true },
  { group = "sapling", sound = "floodables_grass", gain = 0.2 },
  { group = "lib_ecology_sapling", sound = "floodables_grass", gain = 0.2 },
  { group = "plant", sound = "floodables_grass", gain = 0.2 },
  { group = "growing", sound = "floodables_grass", gain = 0.2 },
  { group = "lib_ecology_plant", sound = "floodables_grass", gain = 0.2 },

}

local function node_is_plant(node)
	if not node then
		return false
	end
	if node.name == "ignore" then
		return false
	end

	local name = node.name
	if not minetest.registered_nodes[name] then
		return false
	end
	local drawtype = minetest.registered_nodes[name]["drawtype"]
	if drawtype == "plantlike" then
		return true
	end

	if minetest.registered_nodes[node.name].groups.flora == 1 then
		return true
	end

	return ((name == "default:leaves") or
	        (name == "default:jungleleaves") or
	        (name == "default:pine_needles") or
	        (name == "default:cactus"))
end



for _,c in ipairs(floodables) do
  if c.name ~=nil then
    minetest.override_item(c.name, {
      floodable = true,
      on_flood = function(pos, oldnode, newnode)
        minetest.remove_node(pos)
        if c.sound ~= nil then
          minetest.sound_play({ name = c.sound, gain = c.gain }, { pos = pos, max_hear_distance = 16 })
        end
        if c.drop == nil or c.drop ~= false then c.drop = c.name end
        minetest.add_item(pos, {name = c.drop})
        if c.erode == true then
          minetest.remove_node( { x = pos.x, y = pos.y-1, z = pos.z } )
        end
      end
    })
  elseif c.group ~=nil then
    for _,v in pairs(minetest.registered_nodes) do
    	if minetest.get_item_group(v.name, c.group) ~= 0 then
        minetest.override_item(v.name, {
          floodable = true,
          on_flood = function(pos, oldnode, newnode)
            minetest.remove_node(pos)
            if c.sound ~= nil then
              minetest.sound_play({ name = c.sound, gain = c.gain }, { pos = pos, max_hear_distance = 16 })
            end
            if c.drop == nil or c.drop == true then c.drop = v.name end
            minetest.add_item(pos, {name = c.drop})
            if c.erode == true then
              minetest.remove_node( { x = pos.x, y = pos.y-1, z = pos.z } )
            end
          end
        })
    	end
    end
  end
end
