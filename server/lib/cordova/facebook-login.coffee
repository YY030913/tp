Accounts.registerLoginHandler (loginRequest) ->
	if not loginRequest.cordova
		return undefined

	console.log "loginRequest",loginRequest
	

	if loginRequest.service == "facebook"
		loginRequest = loginRequest.authResponse
		identity = getFacebookIdentity(loginRequest.accessToken)

		serviceData =
			accessToken: loginRequest.accessToken
			expiresAt: (+new Date) + (1000 * loginRequest.expiresIn)

		whitelisted = ['id', 'email', 'name', 'first_name', 'last_name', 'link', 'username', 'gender', 'locale', 'age_range']

		fields = _.pick(identity, whitelisted)
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(identity, whitelisted)
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("facebook", serviceData, options)

	else if loginRequest.service == "weibo"
		identity = getWeiboIdentity(loginRequest.token, loginRequest.uid)

		serviceData =
			accessToken: loginRequest.token
			expiresAt: (+new Date) + (loginRequest.expire_at)

		whitelisted = ['id', 'name', 'screen_name', 'location', 'description', 'profile_url', 'followers_count', 'friends_count', 'verified', 'verified_reason', 'avatar_large']

		fields = _.pick(identity, whitelisted)
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(identity, whitelisted)
		_.extend(options.profile, profileFields)

		console.log "serviceData",serviceData

		console.log "options",options
		
		return Accounts.updateOrCreateUserFromExternalService("weibo", serviceData, options)

	else if loginRequest.service == "google"
		serviceData =
			accessToken: loginRequest.token
			expiresAt: (+new Date) + (loginRequest.expire_at)

		whitelisted = ['userId', 'displayName', 'email', 'location', 'description', 'profile_url', 'followers_count', 'friends_count', 'verified', 'verified_reason', 'avatar_large']

		fields = _.pick(loginRequest, whitelisted)
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(loginRequest, whitelisted)
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("google", serviceData, options)

	else if loginRequest.service == "wechat"
		console.log "wechat"



getFacebookIdentity = (accessToken) ->
	try
		return HTTP.get("https://graph.facebook.com/me", {headers: {"Access-Control-Allow-Origin": "*"}, params: {access_token: accessToken}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Facebook. " + err.message), {response: err.response}


getWeiboIdentity = (token, uid) ->
	try
		return HTTP.get("https://api.weibo.com/2/users/show.json",{params: {access_token: token,uid: uid}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

# 需要scope登录授权，非Cordova中的登录
getWeiboEmail = (token) ->
	try
		return HTTP.get("https://api.weibo.com/2/account/profile/email.json",{params: {access_token: token}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

