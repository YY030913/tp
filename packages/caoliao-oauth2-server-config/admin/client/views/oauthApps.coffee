Template.oauthApps.onCreated ->
	@subscribe 'oauthApps'

Template.oauthApps.helpers
	hasPermission: ->
		return CaoLiao.authz.hasAllPermission 'manage-oauth-apps'

	applications: ->
		return ChatOAuthApps.find()

	dateFormated: (date) ->
		return moment(date).format('L LT')
