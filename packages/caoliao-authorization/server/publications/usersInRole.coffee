Meteor.publish 'usersInRole', (roleName, scope, page = 1) ->
	unless @userId
		return @ready()

	if not CaoLiao.authz.hasPermission @userId, 'access-permissions'
		return @error new Meteor.Error "error-not-allowed", 'Not allowed', { publish: 'usersInRole' }

	itemsPerPage = 20
	pagination =
		sort:
			name: 1
		limit: itemsPerPage
		offset: itemsPerPage * (page - 1)

	return CaoLiao.authz.getUsersInRole roleName, scope, pagination
