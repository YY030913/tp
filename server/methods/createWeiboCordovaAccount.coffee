Meteor.methods
	createWeiboCordovaAccount: (options) ->

		###
		autho = HTTP.get("https://api.weibo.com/oauth2/get_oauth2_token",{params: {client_id: "1500447187",redirect_uri: "http://127.0.0.1/_oauth/weibo"}})

		console.log autho

		HTTP.post("https://api.weibo.com/oauth2/access_token",
		{params: {client_id: options.token,client_secret: options.uid,}}

		https://api.weibo.com/2/eps/user/info.json
		###
		result = HTTP.get("https://api.weibo.com/2/users/show.json",{params: {access_token: options.token,uid: options.uid}});

		if result.error?
			throw new Meteor.Error 'error-http-get', 'Http Get Error', { method: 'createWeiboCordovaAccount' }
		else if result.follow == 0
			throw new Meteor.Error 'error-need-follow', 'error-need-follow', { method: 'createWeiboCordovaAccount' } #TAPi18n.__("error-need-follow");
		
		if result?.data?.id?
			options = _.extend options, result.data

			option = {}
			option.profile = {}
			option.profile.name = options.displayName

			options.id = options.uid
			options.picture = options.profile_image_url
			options.username = options.screen_name

			user = Accounts.updateOrCreateUserFromExternalService('weibo', options, option);

			resume = Random.secret();
			now = new Date();
			return Accounts._attemptLogin(DDP._CurrentInvocation.get(), "login", {oauth: {credentialToken: Random.secret(), credentialSecret: Random.secret()}}, {type: 'weibo', userId: user.userId})

