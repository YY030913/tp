Meteor.publish 'typeSelectTag',  ->
	unless this.userId
		return this.ready()

	
	return CaoLiao.models.Tags.findForUser(this.userId)