usergroups = {}
groups = {}


usergroups.modpath = minetest.get_modpath("usergroups")

filepath = minetest.get_worldpath().."/usergroups.dat"

function users_to_string(users)
    local str = ""
    for name, v in pairs(users) do
        str = str..name.." "
    end
    return str
end

function usergroups:save()
    datastr = minetest.serialize(groups)

    local file, err = io.open(filepath, "w")
    if err then
        return err
    end
    file:write(datastr)
    file:close()
end

function usergroups:load()
    local file, err = io.open(filepath, "r")
    if err then
        groups = groups or {}
        return err
    end

    groups = minetest.deserialize(file:read("*a"))
    if type(groups) ~= "table" then
        groups = {}
    end

    file:close()
end

minetest.register_chatcommand("groups_add", {
    params = "<group> <user>",
    description = "Add a user to a group",
    privs = {["server"] = true},
    func = function(name, param)
        local group, user = param:match('^(%S+)%s(%S+)$')

        if not group then
            return false, "No group specified"
        end

        if not user then
            return false, "No user specified"
        end

        if not groups[group] then
            groups[group] = {}
        end

        groups[group][user] = true

        usergroups:save()

        return true, "User groups updated."
    end
})


minetest.register_chatcommand("groups_list_users", {
    params = "<group>",
    description = "List users that belong to a group",
    privs = {["server"] = true},
    func = function(name, param)
        local group = param

        if not group then
            return false, "No group specified"
        end

        if not groups[group] then
            return false, "Group "..group.."does not exist!"
        end

        return true, "Users in "..group..": "..users_to_string(groups[group])
    end
})

usergroups:load()
