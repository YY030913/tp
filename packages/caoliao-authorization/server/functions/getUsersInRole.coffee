CaoLiao.authz.getUsersInRole = (roleName, scope, options) ->
	return CaoLiao.models.Roles.findUsersInRole(roleName, scope, options)
