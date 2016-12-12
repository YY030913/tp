Meteor.methods
	createWeiboCordovaAccount: (options) ->

		result = HTTP.get("https://api.weibo.com/2/eps/user/info.json",{headers: {Access-Control-Allow-Origin: *}, params: {access_token: options.token,uid: options.uid}}).data;

		console.log "rs",JSON.stringify(result)
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

