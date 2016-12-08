config =
	serverURL: 'https://gitlab.com'
	identityPath: '/api/v3/user'
	addAutopublishFields:
		forLoggedInUser: ['services.gitlab']
		forOtherUsers: ['services.gitlab.username']

Gitlab = new CustomOAuth 'gitlab', config

if Meteor.isServer
	Meteor.startup ->
		CaoLiao.models.Settings.findById('API_Gitlab_URL').observe
			added: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
			changed: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if CaoLiao.settings.get 'API_Gitlab_URL'
				config.serverURL = CaoLiao.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
