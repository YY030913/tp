Meteor.methods
	migrateTo: (version) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'migrateTo' }

		user = Meteor.user()

		if not user? or CaoLiao.authz.hasPermission(user._id, 'run-migration') isnt true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'migrateTo' }

		this.unblock()
		CaoLiao.Migrations.migrateTo version
		return version

	getMigrationVersion: ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getMigrationVersion' }

		return CaoLiao.Migrations.getVersion()
