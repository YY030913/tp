CaoLiao.authz.addUserRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = CaoLiao.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'invalid-user'

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(CaoLiao.authz.getRoles(), '_id')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		for role in invalidRoleNames
			CaoLiao.models.Roles.createOrUpdate role

	CaoLiao.models.Roles.addUserRoles(userId, roleNames, scope)

	return true
