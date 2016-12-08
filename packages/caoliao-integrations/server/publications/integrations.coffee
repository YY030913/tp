Meteor.publish 'integrations', ->
	unless @userId
		return @ready()

	if CaoLiao.authz.hasPermission @userId, 'manage-integrations'
		return CaoLiao.models.Integrations.find()
	else if CaoLiao.authz.hasPermission @userId, 'manage-own-integrations'
		return CaoLiao.models.Integrations.find({"_createdBy._id": @userId})
	else
		throw new Meteor.Error "not-authorized"
