usergroups = {}

local groups = {}

usergroups.modpath = minetest.get_modpath("usergroups")

filepath = minetest.get_worldpath().."/usergroups.dat"

function indexes_to_string(users)
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

function usergroups:get_groups()
  local gr = {}
  for group, _ in pairs(groups) do
    table.insert(gr, group)
  end
  return gr
end

function usergroups:get_users(group)
  local users = {}

  if not usergroups:group_exists(group) then
    return {}
  end

  for name, _ in pairs(groups[group]) do
      table.insert(users, name)
  end

  return users
end

function usergroups:group_exists(group)
    if not groups then
      return false
    end

    return (groups[group] ~= nil)
end

function usergroups:user_is_in_group(user, group)
  if not usergroups:group_exists(group) then
    return false
  end

  for name, _ in pairs(groups[group]) do
    if name == user then
      return true
    end
  end

  return false
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

        return true, "Users in "..group..": "..indexes_to_string(groups[group])
    end
})

minetest.register_chatcommand("groups_remove", {
    params = "<group> <user>",
    description = "Remove a user from a group",
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
            return false, "Group "..group.."does not exist!"
        end

        groups[group][user] = nil

        if next(groups[group]) == nil then
            -- group is empty, delete group
            groups[group] = nil
        end

        usergroups:save()

        return true, "Users in "..group..": "..indexes_to_string(groups[group])
    end
})

minetest.register_chatcommand("groups_list", {
    params = "[group]",
    description = "List available groups, or users of a group",
    privs = {["server"] = true},
    func = function(name, param)
        local group = param

        if not groups then
            return false, "No groups available"
        end

        if not group or group == "" then
            return true, "Available groups: "..indexes_to_string(groups)
        end

        if not groups[group] then
            return false, "Group "..group.."does not exist!"
        end

        return true, "Users in "..group..": "..indexes_to_string(groups[group])
    end
})

usergroups:load()
