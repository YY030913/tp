CaoLiao.Migrations.add
	version: 27
	up: ->
		CaoLiao.models.Users.update({}, { $rename: { roles: '_roles' } }, { multi: true })

		CaoLiao.models.Users.find({ _roles: { $exists: 1 } }).forEach (user) ->
			for scope, roles of user._roles
				CaoLiao.models.Roles.addUserRoles(user._id, roles, scope)

		CaoLiao.models.Users.update({}, { $unset: { _roles: 1 } }, { multi: true })
