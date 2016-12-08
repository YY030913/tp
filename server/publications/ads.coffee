Meteor.publish 'ads', () ->
	unless this.userId
		return this.ready()

	CaoLiao.models.Ad.findAllOpen()