# GitHub Enterprise Server CallBack URL needs to be http(s)://{caoliao.server}[:port]/_oauth/github_enterprise
# In CaoLiao -> Administration the URL needs to be http(s)://{github.enterprise.server}/
config =
	serverURL: ''
	identityPath: '/api/v3/user'
	authorizePath: '/login/oauth/authorize'
	tokenPath: '/login/oauth/access_token'
	addAutopublishFields:
		forLoggedInUser: ['services.github-enterprise']
		forOtherUsers: ['services.github-enterprise.username']

GitHubEnterprise = new CustomOAuth 'github_enterprise', config

if Meteor.isServer
	Meteor.startup ->
		CaoLiao.models.Settings.findById('API_GitHub_Enterprise_URL').observe
			added: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
			changed: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if CaoLiao.settings.get 'API_GitHub_Enterprise_URL'
				config.serverURL = CaoLiao.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
