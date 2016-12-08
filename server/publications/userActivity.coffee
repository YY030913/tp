Meteor.publish 'userActivity', (userid)->
	unless this.userId
		return this.ready()

	if userid
		queryUserId = userid
	else
		queryUserId = this.userId

	CaoLiao.models.Activity.findByUser queryUserId


