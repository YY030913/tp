Meteor.methods
	toggleFavorite: (rid, f) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'toggleFavorite' })

		CaoLiao.models.Subscriptions.setFavoriteByRoomIdAndUserId rid, Meteor.userId(), f
