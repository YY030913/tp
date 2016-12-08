Meteor.methods
	addRoomOwner: (rid, userId) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'addRoomOwner' }

		check rid, String
		check userId, String

		unless CaoLiao.authz.hasPermission Meteor.userId(), 'set-owner', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'addRoomOwner' }

		subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'addRoomOwner' }

		CaoLiao.models.Subscriptions.addRoleById(subscription._id, 'owner')

		user = CaoLiao.models.Users.findOneById userId
		fromUser = CaoLiao.models.Users.findOneById Meteor.userId()
		CaoLiao.models.Messages.createSubscriptionRoleAddedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'owner'

		if CaoLiao.settings.get('UI_DisplayRoles')
			CaoLiao.Notifications.notifyAll('roles-change', { type: 'added', _id: 'owner', u: { _id: user._id, username: user.username }, scope: rid });

		return true
