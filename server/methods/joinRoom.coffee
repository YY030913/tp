Meteor.methods
	joinRoom: (rid) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'joinRoom' }

		room = CaoLiao.models.Rooms.findOneById rid
		if not room?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'joinRoom' }

		if room.t isnt 'c' or CaoLiao.authz.hasPermission(Meteor.userId(), 'view-c-room') isnt true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'joinRoom' }

		now = new Date()

		# Check if user is already in room
		subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId rid, Meteor.userId()
		if subscription?
			return
		user = CaoLiao.models.Users.findOneById Meteor.userId()

		CaoLiao.callbacks.run 'beforeJoinRoom', user, room

		CaoLiao.models.Rooms.addUsernameById rid, user.username

		CaoLiao.models.Subscriptions.createWithRoomAndUser room, user,
			ts: now
			open: true
			alert: true
			unread: 1


		CaoLiao.models.Messages.createUserJoinWithRoomIdAndUser rid, user,
			ts: now

		Meteor.defer ->

			activity = CaoLiao.Activity.utils.add(room.name, "", 'join_room', 'Join_Room')
			activity.userId = this.userId
			CaoLiao.models.Activity.createActivity(activity)

			###
			score = CaoLiao.Score.utils.add(room._id, 'join_room', 'Join_Room')
			CaoLiao.models.Score.update(this.userId, score, CaoLiao.Score.utils.joinRoom)
			###

			CaoLiao.callbacks.run 'afterJoinRoom', user, room

		return true
