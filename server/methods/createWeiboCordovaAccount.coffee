Meteor.methods
	createWeiboCordovaAccount: (options) ->

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

