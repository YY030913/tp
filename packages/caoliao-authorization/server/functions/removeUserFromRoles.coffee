CaoLiao.authz.removeUserFromRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = CaoLiao.models.Users.findOneById(userId)
	if not user?
		throw new Meteor.Error 'error-invalid-user', 'Invalid user', { function: 'CaoLiao.authz.removeUserFromRoles' }

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(CaoLiao.authz.getRoles(), 'name')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		throw new Meteor.Error 'error-invalid-role', 'Invalid role', { function: 'CaoLiao.authz.removeUserFromRoles' }

	CaoLiao.models.Roles.removeUserRoles(userId, roleNames, scope)

	return true
