Meteor.publish 'friendSubscriptionData', ->
	unless this.userId
		return this.ready()

	CaoLiao.models.FriendsSubscriptions.findByUserId this.userId,
		fields:
			open: 1
			alert: 1
			unread: 1
			u: 1


