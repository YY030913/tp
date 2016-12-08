Meteor.methods
	removeRoomOwner: (rid, userId) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeRoomOwner' }

		check rid, String
		check userId, String

		unless CaoLiao.authz.hasPermission Meteor.userId(), 'set-owner', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeRoomOwner' }

		subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'removeRoomOwner' }

		numOwners = CaoLiao.authz.getUsersInRole('owner', rid).count()
		if numOwners is 1
			throw new Meteor.Error 'error-remove-last-owner', 'This is the last owner. Please set a new owner before removing this one.', { method: 'removeRoomOwner' }

		CaoLiao.models.Subscriptions.removeRoleById(subscription._id, 'owner')

		user = CaoLiao.models.Users.findOneById userId
		fromUser = CaoLiao.models.Users.findOneById Meteor.userId()
		CaoLiao.models.Messages.createSubscriptionRoleRemovedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'owner'

		if CaoLiao.settings.get('UI_DisplayRoles')
			CaoLiao.Notifications.notifyAll('roles-change', { type: 'removed', _id: 'owner', u: { _id: user._id, username: user.username }, scope: rid });

		return true
