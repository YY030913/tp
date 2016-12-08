Meteor.methods
	archiveRoom: (rid) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'archiveRoom' }

		room = CaoLiao.models.Rooms.findOneById rid

		unless room
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'archiveRoom' }

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'archive-room', room._id)
			throw new Meteor.Error 'error-not-authorized', 'Not authorized', { method: 'archiveRoom' }

		CaoLiao.models.Rooms.archiveById rid

		for username in room.usernames
			member = CaoLiao.models.Users.findOneByUsername(username, { fields: { username: 1 }})
			if not member?
				continue

			CaoLiao.models.Subscriptions.archiveByRoomIdAndUserId rid, member._id
