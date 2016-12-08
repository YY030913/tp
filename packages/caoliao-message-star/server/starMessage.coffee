Meteor.methods
	starMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'starMessage' })

		if not CaoLiao.settings.get 'Message_AllowStarring'
			throw new Meteor.Error 'error-action-not-allowed', 'Message starring not allowed', { method: 'pinMessage', action: 'Message_starring' }

		room = CaoLiao.models.Rooms.findOne({ _id: message.rid })

		if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
			return false

		CaoLiao.models.Messages.updateUserStarById(message._id, Meteor.userId(), message.starred)
