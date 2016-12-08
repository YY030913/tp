Meteor.publish 'rooms', () ->
	unless this.userId
		return this.ready()

	user = CaoLiao.models.Users.findOneById this.userId


	CaoLiao.models.Rooms.findByUsername user.username,
		fields:
			_id: 1
			usernames: 1