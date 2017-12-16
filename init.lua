usergroups = {}


usergroups.modpath = minetest.get_modpath("usergroups")


filepath = minetest.get_worldpath().."/usergroups.dat" 

function usermods:save()
    local data = {foo = "bar"}
    datastr = minetest.serialize(data)

    local file, err = io.open(filepath, "w")
    if err then
        return err
    end
    file:write(datastr)
    file:close()
end

usermods:save()
