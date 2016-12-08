Meteor.methods
	startDebate: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'startDebate' }

		if CaoLiao.authz.hasPermission(user._id, 'update-debate-favorite') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'startDebate' }

		now = new Date()

		option = {
			name: 1
		}

		u = {
			_id: user._id,
			name: user.username
		}

		debate = CaoLiao.models.Debates.findOne {_id: _id}
		
		if debate?
			CaoLiao.models.Debates.pushFavoriteById _id, u
		return true