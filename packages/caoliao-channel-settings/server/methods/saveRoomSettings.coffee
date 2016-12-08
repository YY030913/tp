Meteor.methods
	saveRoomSettings: (rid, setting, value) ->
		unless Match.test rid, String
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'saveRoomSettings' }

		if setting not in ['roomName', 'roomTopic', 'roomType', 'default']
			throw new Meteor.Error 'error-invalid-settings', 'Invalid settings provided', { method: 'saveRoomSettings' }

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'edit-room', rid)
			throw new Meteor.Error 'error-action-not-allowed', 'Editing room is not allowed', { method: 'saveRoomSettings', action: 'Editing_room' }

		if setting is 'default' and not CaoLiao.authz.hasPermission(@userId, 'view-room-administration')
			throw new Meteor.Error 'error-action-not-allowed', 'Viewing room administration is not allowed', { method: 'saveRoomSettings', action: 'Viewing_room_administration' }

		room = CaoLiao.models.Rooms.findOneById rid
		if room?
			switch setting
				when 'roomName'
					name = CaoLiao.saveRoomName rid, value
					CaoLiao.models.Messages.createRoomRenamedWithRoomIdRoomNameAndUser rid, name, Meteor.user()
				when 'roomTopic'
					if value isnt room.topic
						CaoLiao.saveRoomTopic(rid, value)
						CaoLiao.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_topic', rid, value, Meteor.user()
				when 'roomType'
					if value isnt room.t
						CaoLiao.saveRoomType(rid, value)
						if value is 'c'
							message = TAPi18n.__('Channel')
						else
							message = TAPi18n.__('Private_Group')
						CaoLiao.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_privacy', rid, message, Meteor.user()
				when 'default'
					CaoLiao.models.Rooms.saveDefaultById rid, value

		return true
