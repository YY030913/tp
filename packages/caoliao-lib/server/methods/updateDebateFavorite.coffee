Meteor.methods
	updateDebateFavorite: (_id) ->
		user = Meteor.user()
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateFavorite' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'update-debate-favorite') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateFavorite' }

		

		debate = CaoLiao.models.Debates.findOne {_id: _id}
		
		if debate?
			CaoLiao.models.Debates.pushFavoriteById _id, {userId: user._id, username: user.username}

		return true