Meteor.methods
	createGoogleCordovaAccount: (options) ->
		option = {}
		option.profile = {}
		option.profile.name = options.displayName

		console.log "call createGoogleCordovaAccount"
		options.id = options.userId

		user = Accounts.updateOrCreateUserFromExternalService('google', options, option);
		console.log("user",user);
		resume = Random.secret();
		now = new Date();
		return Accounts._attemptLogin(DDP._CurrentInvocation.get(), "login", {oauth: {credentialToken: Random.secret(), credentialSecret: Random.secret()}}, {type: 'google', userId: user.userId})

