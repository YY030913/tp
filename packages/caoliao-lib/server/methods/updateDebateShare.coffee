Meteor.methods
	updateDebateShare: (_id) ->
		
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateShare' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'update-debate-share') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateShare' }

		user = Meteor.user()

		debate = CaoLiao.models.Debates.findOne {_id: _id}
		
		if debate?
			CaoLiao.models.Debates.pushShareById _id, {userId: user._id, username: user.username}

		return true