Meteor.methods
	pinMessage: (message) ->
		if not Meteor.userId()
			return false

		if not CaoLiao.settings.get 'Message_AllowPinning'
			return false

		room = CaoLiao.models.Rooms.findOne({ _id: message.rid })

		if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
			return false

		ChatMessage.update
			_id: message._id
		,
			$set: { pinned: true }

	unpinMessage: (message) ->
		if not Meteor.userId()
			return false

		if not CaoLiao.settings.get 'Message_AllowPinning'
			return false

		room = CaoLiao.models.Rooms.findOne({ _id: message.rid })

		if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
			return false

		ChatMessage.update
			_id: message._id
		,
			$set: { pinned: false }
