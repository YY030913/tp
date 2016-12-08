Meteor.methods
	eraseRoom: (rid) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'eraseRoom' }

		fromId = Meteor.userId()

		roomType = CaoLiao.models.Rooms.findOneById(rid)?.t

		if CaoLiao.authz.hasPermission( fromId, "delete-#{roomType}", rid )
			# ChatRoom.update({ _id: rid}, {'$pull': { userWatching: Meteor.userId(), userIn: Meteor.userId() }})

			CaoLiao.models.Messages.removeByRoomId rid
			CaoLiao.models.Subscriptions.removeByRoomId rid
			CaoLiao.models.Rooms.removeById rid
			# @TODO remove das mensagens lidas do usuário
		else
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'eraseRoom' }
