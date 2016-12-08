Meteor.methods
	removeUserFromRoom: (data) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeUserFromRoom' }

		fromId = Meteor.userId()
		check(data, Match.ObjectIncluding({ rid: String, username: String }))

		unless CaoLiao.authz.hasPermission(fromId, 'remove-user', data.rid)
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeUserFromRoom' }

		room = CaoLiao.models.Rooms.findOneById data.rid

		if data.username not in (room?.usernames or [])
			throw new Meteor.Error 'error-user-not-in-room', 'User is not in this room', { method: 'removeUserFromRoom' }

		removedUser = CaoLiao.models.Users.findOneByUsername data.username

		CaoLiao.models.Rooms.removeUsernameById data.rid, data.username

		CaoLiao.models.Subscriptions.removeByRoomIdAndUserId data.rid, removedUser._id

		if room.t in [ 'c', 'p' ]
			CaoLiao.authz.removeUserFromRoles(removedUser._id, ['moderator', 'owner'], data.rid)

		fromUser = CaoLiao.models.Users.findOneById fromId
		CaoLiao.models.Messages.createUserRemovedWithRoomIdAndUser data.rid, removedUser,
			u:
				_id: fromUser._id
				username: fromUser.username

		return true
