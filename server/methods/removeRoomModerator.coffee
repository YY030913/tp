Meteor.methods
	removeRoomModerator: (rid, userId) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeRoomModerator' }

		check rid, String
		check userId, String

		unless CaoLiao.authz.hasPermission Meteor.userId(), 'set-moderator', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeRoomModerator' }

		subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'removeRoomModerator' }

		CaoLiao.models.Subscriptions.removeRoleById(subscription._id, 'moderator')

		user = CaoLiao.models.Users.findOneById userId
		fromUser = CaoLiao.models.Users.findOneById Meteor.userId()
		CaoLiao.models.Messages.createSubscriptionRoleRemovedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'moderator'

		if CaoLiao.settings.get('UI_DisplayRoles')
			CaoLiao.Notifications.notifyAll('roles-change', { type: 'removed', _id: 'moderator', u: { _id: user._id, username: user.username }, scope: rid });

		return true
