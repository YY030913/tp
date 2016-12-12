Meteor.methods
	createFackbookCordovaAccount: (options) ->
		option = {}
		option.profile = {}
		option.profile.name = options.displayName

		console.log "call createFackbookCordovaAccount"
		options.id = options.userID

		user = Accounts.updateOrCreateUserFromExternalService('facebook', options, option);
		
		resume = Random.secret();
		now = new Date();
		return Accounts._attemptLogin(DDP._CurrentInvocation.get(), "login", {oauth: {credentialToken: Random.secret(), credentialSecret: Random.secret()}}, {type: 'facebook', userId: user.userId})

