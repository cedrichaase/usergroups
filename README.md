# usergroups

This minetest mod allows managing user groups via a number of chat commands.
Users can be added to and removed from groups.

Group membership can be queried by other mods using usergroups' API.


## Chat Command Reference

### `/groups_list [group]`

If no group is provided, this will list all available groups.
If a group name is provided, this will list all members of the group.

### `/groups_add <group> <username>`

Adds a user to a group. If the group does not exist, it will be created first.

### `/groups_remove <group> <username>`

Removes a user from a group.


## API Reference

All `usergroups` data should be accessed via the global `usergroups` table.

### `usergroups:get_groups()`

Returns an array-like table of all existing groups.

### `usergroups:get_users(group)`

Returns an array-like table of users that belong to the given group.

### `usergroups:group_exists(group)`

Returns `true` if the group exists, `false` if it doesn't.

### `usergroups:user_is_in_group(user, group)`

Returns `true` if given user is a member of the group and `false` if not.
