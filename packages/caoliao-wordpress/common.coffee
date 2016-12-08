config =
	serverURL: ''
	identityPath: '/oauth/me'
	addAutopublishFields:
		forLoggedInUser: ['services.wordpress']
		forOtherUsers: ['services.wordpress.user_login']

WordPress = new CustomOAuth 'wordpress', config

if Meteor.isServer
	Meteor.startup ->
		CaoLiao.models.Settings.find({ _id: 'API_Wordpress_URL' }).observe
			added: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_Wordpress_URL'
				WordPress.configure config
			changed: (record) ->
				config.serverURL = CaoLiao.settings.get 'API_Wordpress_URL'
				WordPress.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if CaoLiao.settings.get 'API_Wordpress_URL'
				config.serverURL = CaoLiao.settings.get 'API_Wordpress_URL'
				WordPress.configure config
