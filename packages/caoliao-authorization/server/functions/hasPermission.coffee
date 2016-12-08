CaoLiao.authz.hasPermission = (userId, permissionId, scope) ->
	permission = CaoLiao.models.Permissions.findOne permissionId
	return CaoLiao.models.Roles.isUserInRoles(userId, permission.roles, scope)
