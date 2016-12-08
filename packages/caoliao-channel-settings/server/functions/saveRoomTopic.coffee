CaoLiao.saveRoomTopic = (rid, roomTopic) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'CaoLiao.saveRoomTopic' }

	return CaoLiao.models.Rooms.setTopicById(rid, roomTopic)
