Meteor.methods
	'authorization:addPermissionToRole': (permission, role) ->
		if not Meteor.userId() or not CaoLiao.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error 'error-action-not-allowed', 'Adding permission is not allowed', { method: 'authorization:addPermissionToRole', action: 'Adding_permission' }

		CaoLiao.models.Permissions.addRole permission, role
