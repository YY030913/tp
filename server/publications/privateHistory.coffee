Meteor.publish 'privateHistory', ->
	unless this.userId
		return this.ready()

	CaoLiao.models.Rooms.findByContainigUsername CaoLiao.models.Users.findOneById(this.userId).username,
		fields:
			t: 1
			name: 1
			msgs: 1
			ts: 1
			lm: 1
			cl: 1

