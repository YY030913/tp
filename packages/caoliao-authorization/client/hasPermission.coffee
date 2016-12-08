atLeastOne = (permissions, scope) ->
	return _.some permissions, (permissionId) ->
		permission = ChatPermissions.findOne permissionId
		return _.some permission.roles, (roleName) ->
			role = CaoLiao.models.Roles.findOne roleName
			roleScope = role?.scope
			return CaoLiao.models[roleScope]?.isUserInRole?(Meteor.userId(), roleName, scope)

all = (permissions, scope) ->
	return _.every permissions, (permissionId) ->
		permission = ChatPermissions.findOne permissionId
		return _.some permission.roles, (roleName) ->
			role = CaoLiao.models.Roles.findOne roleName
			roleScope = role?.scope
			return CaoLiao.models[roleScope]?.isUserInRole?(Meteor.userId(), roleName, scope)

Template.registerHelper 'hasPermission', (permission, scope) ->
	return hasPermission(permission, scope, atLeastOne)

CaoLiao.authz.hasAllPermission = (permissions, scope) ->
	return hasPermission(permissions, scope, all)

CaoLiao.authz.hasAtLeastOnePermission = (permissions, scope) ->
	return hasPermission(permissions, scope, atLeastOne)

hasPermission = (permissions, scope, strategy) ->
	userId = Meteor.userId()

	unless userId
		return false

	unless CaoLiao.authz.subscription.ready()
		return false

	permissions = [].concat permissions

	return strategy(permissions, scope)
