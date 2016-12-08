Meteor.methods
	setUserActiveStatus: (userId, active) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'setUserActiveStatus' }

		unless CaoLiao.authz.hasPermission( Meteor.userId(), 'edit-other-user-active-status') is true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'setUserActiveStatus' }

		CaoLiao.models.Users.setUserActive userId, active

		if active is false
			CaoLiao.models.Users.unsetLoginTokens userId

		return true
