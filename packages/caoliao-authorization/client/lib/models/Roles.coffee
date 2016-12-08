CaoLiao.models.Roles = new Meteor.Collection 'caoliao_roles'

CaoLiao.models.Roles.findUsersInRole = (name, scope, options) ->
	role = @findOne name
	roleScope = role?.scope or 'Users'
	CaoLiao.models[roleScope]?.findUsersInRoles?(name, scope, options)

CaoLiao.models.Roles.isUserInRoles = (userId, roles, scope) ->
	roles = [].concat roles
	_.some roles, (roleName) =>
		role = @findOne roleName
		roleScope = role?.scope or 'Users'
		return CaoLiao.models[roleScope]?.isUserInRole?(userId, roleName, scope)

