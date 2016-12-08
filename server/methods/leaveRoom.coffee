Meteor.methods
	leaveRoom: (rid) ->
		unless Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'leaveRoom' })

		this.unblock()

		fromId = Meteor.userId()
		room = CaoLiao.models.Rooms.findOneById rid
		user = Meteor.user()

		# If user is room owner, check if there are other owners. If there isn't anyone else, warn user to set a new owner.
		if CaoLiao.authz.hasRole(user._id, 'owner', room._id)
			numOwners = CaoLiao.authz.getUsersInRole('owner', room._id).fetch().length
			if numOwners is 1
				throw new Meteor.Error 'error-you-are-last-owner', 'You are the last owner. Please set new owner before leaving the room.', { method: 'leaveRoom' }

		CaoLiao.callbacks.run 'beforeLeaveRoom', user, room

		CaoLiao.models.Rooms.removeUsernameById rid, user.username

		if room.usernames.indexOf(user.username) isnt -1
			removedUser = user
			CaoLiao.models.Messages.createUserLeaveWithRoomIdAndUser rid, removedUser

		if room.t is 'l'
			CaoLiao.models.Messages.createCommandWithRoomIdAndUser 'survey', rid, user

		CaoLiao.models.Subscriptions.removeByRoomIdAndUserId rid, Meteor.userId()

		Meteor.defer ->

			CaoLiao.callbacks.run 'afterLeaveRoom', user, room
