Meteor.startup ->
	CaoLiao.roomTypes.setPublish 'c', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				left: 1
				right: 1
				connected: 1
				archived: 1
				invite: 1
				did: 1

		if CaoLiao.authz.hasPermission(this.userId, 'view-c-room')
			return CaoLiao.models.Rooms.findByTypeAndName 'c', identifier, options
		else if CaoLiao.authz.hasPermission(this.userId, 'view-joined-room')
			roomId = CaoLiao.models.Subscriptions.findByTypeNameAndUserId('c', identifier, this.userId).fetch()
			if roomId.length > 0
				return CaoLiao.models.Rooms.findById(roomId[0]?.rid, options)
		return this.ready()

	CaoLiao.roomTypes.setPublish 'p', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				left: 1
				right: 1
				connected: 1
				invite: 1
				archived: 1

		user = CaoLiao.models.Users.findOneById this.userId, fields: username: 1
		return CaoLiao.models.Rooms.findByTypeAndNameContainigUsername 'p', identifier, user.username, options

	CaoLiao.roomTypes.setPublish 'd', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				left: 1
				right: 1
				connected: 1
				invite: 1
		user = CaoLiao.models.Users.findOneById this.userId, fields: username: 1
		if CaoLiao.authz.hasPermission(this.userId, 'view-d-room')
			return CaoLiao.models.Rooms.findByTypeContainigUsernames 'd', [user.username, identifier], options
		return this.ready()
