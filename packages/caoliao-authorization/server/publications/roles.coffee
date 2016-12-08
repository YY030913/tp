Meteor.publish 'roles', ->
	unless @userId
		return @ready()

	return CaoLiao.models.Roles.find()

