Meteor.methods
	joinDefaultChannels: (silenced) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'joinDefaultChannels' })

		this.unblock()

		user = Meteor.user()

		CaoLiao.callbacks.run 'beforeJoinDefaultChannels', user

		defaultRooms = CaoLiao.models.Rooms.findByDefaultAndTypes(true, ['c', 'p'], {fields: {usernames: 0}}).fetch()

		defaultRooms.forEach (room) ->

			# put user in default rooms
			CaoLiao.models.Rooms.addUsernameById room._id, user.username

			if not CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)?

				# Add a subscription to this user
				CaoLiao.models.Subscriptions.createWithRoomAndUser room, user,
					ts: new Date()
					open: true
					alert: true
					unread: 1

				# Insert user joined message
				if not silenced
					CaoLiao.models.Messages.createUserJoinWithRoomIdAndUser room._id, user
