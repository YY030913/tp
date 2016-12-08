Meteor.methods
	channelsList: (filter, limit, sort) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'channelsList' }

		options =  { fields: { name: 1 }, sort: { msgs:-1 } }
		if _.isNumber limit
			options.limit = limit
		if _.trim(sort)
			switch sort
				when 'name'
					options.sort = { name: 1 }
				when 'msgs'
					options.sort = { msgs: -1 }

		if CaoLiao.authz.hasPermission Meteor.userId(), 'view-c-room'
			if filter
				return { channels: CaoLiao.models.Rooms.findByNameContainingAndTypes(filter, ['c'], options).fetch() }
			else
				return { channels: CaoLiao.models.Rooms.findByTypeAndArchivationState('c', false, options).fetch() }
		else if CaoLiao.authz.hasPermission Meteor.userId(), 'view-joined-room'
			roomIds = _.pluck CaoLiao.models.Subscriptions.findByTypeAndUserId('c', Meteor.userId()).fetch(), 'rid'
			return { channels: CaoLiao.models.Rooms.findByIds(roomIds, options).fetch() }
		else
			return { channels: [] }
