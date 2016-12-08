Meteor.methods
	deleteUser: (userId) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'deleteUser' }

		user = CaoLiao.models.Users.findOneById Meteor.userId()

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'delete-user') is true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'deleteUser' }

		user = CaoLiao.models.Users.findOneById userId
		unless user?
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'deleteUser' }

		CaoLiao.deleteUser(userId)

		return true
