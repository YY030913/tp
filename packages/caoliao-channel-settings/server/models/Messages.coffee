CaoLiao.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser = (type, roomId, message, user, extraData) ->
	return @createWithTypeRoomIdMessageAndUser type, roomId, message, user, extraData

CaoLiao.models.Messages.createRoomRenamedWithRoomIdRoomNameAndUser = (roomId, roomName, user, extraData) ->
	return @createWithTypeRoomIdMessageAndUser 'r', roomId, roomName, user, extraData
