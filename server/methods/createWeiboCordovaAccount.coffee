Meteor.methods
	createWeiboCordovaAccount: (options) ->

		###
		autho = HTTP.get("https://api.weibo.com/oauth2/get_oauth2_token",{params: {client_id: "1500447187",redirect_uri: "http://127.0.0.1/_oauth/weibo"}})

		console.log autho

		HTTP.post("https://api.weibo.com/oauth2/access_token",
		{params: {client_id: options.token,client_secret: options.uid,}}
		###
		result = HTTP.get("https://api.weibo.com/2/eps/user/info.json",{params: {access_token: options.token,uid: options.uid}});

		console.log "rs",result
		if result.error?
			throw new Meteor.Error 'error-http-get', 'Http Get Error', { method: 'createWeiboCordovaAccount' }
		else if result.follow == 0
			throw new Meteor.Error 'error-need-follow', 'error-need-follow', { method: 'createWeiboCordovaAccount' } #TAPi18n.__("error-need-follow");
		
		options = _.extend options, result

		option = {}
		option.profile = {}
		option.profile.name = options.displayName

		console.log "call createWeiboCordovaAccount"
		options.id = options.uid
		options.picture = options.headimgurl
		options.username = options.nicname

		user = Accounts.updateOrCreateUserFromExternalService('weibo', options, option);

		resume = Random.secret();
		now = new Date();
		return Accounts._attemptLogin(DDP._CurrentInvocation.get(), "login", {oauth: {credentialToken: Random.secret(), credentialSecret: Random.secret()}}, {type: 'weibo', userId: user.userId})

