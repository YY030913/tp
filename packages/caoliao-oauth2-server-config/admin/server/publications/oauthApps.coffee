Meteor.publish 'oauthApps', ->
	unless @userId
		return @ready()

	if not CaoLiao.authz.hasPermission @userId, 'manage-oauth-apps'
		@error Meteor.Error "error-not-allowed", "Not allowed", { publish: 'oauthApps' }

	return CaoLiao.models.OAuthApps.find()
