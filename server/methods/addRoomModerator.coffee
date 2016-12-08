Meteor.methods
	addRoomModerator: (rid, userId) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'addRoomModerator' }

		check rid, String
		check userId, String

		unless CaoLiao.authz.hasPermission Meteor.userId(), 'set-moderator', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'addRoomModerator' }

		subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'addRoomModerator' }

		CaoLiao.models.Subscriptions.addRoleById(subscription._id, 'moderator')

		user = CaoLiao.models.Users.findOneById userId
		fromUser = CaoLiao.models.Users.findOneById Meteor.userId()
		CaoLiao.models.Messages.createSubscriptionRoleAddedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'moderator'

		if CaoLiao.settings.get('UI_DisplayRoles')
			CaoLiao.Notifications.notifyAll('roles-change', { type: 'added', _id: 'moderator', u: { _id: user._id, username: user.username }, scope: rid });

		return true
