#fiber = Npm.require('fibers');
#connect = Npm.require('connect');

oauth2server = new OAuth2Server
	accessTokensCollectionName: 'caoliao_oauth_access_tokens'
	refreshTokensCollectionName: 'caoliao_oauth_refresh_tokens'
	authCodesCollectionName: 'caoliao_oauth_auth_codes'
	clientsCollection: CaoLiao.models.OAuthApps.model
	debug: true


WebApp.connectHandlers.use oauth2server.app
###
WebApp.connectHandlers.use connect.bodyParser().use (req, res, next) ->
	fiber ->
		oauth2server.app
		console.log("oauth2server", req.body);
###

Meteor.publish 'oauthClient', (clientId) ->
	unless @userId
		return @ready()

	return CaoLiao.models.OAuthApps.find {clientId: clientId, active: true},
		fields:
			name: 1


CaoLiao.API.v1.addAuthMethod ->
	console.log @request.method, @request.url

	headerToken = @request.headers['authorization']
	getToken = @request.query.access_token

	if headerToken?
		if matches = headerToken.match(/Bearer\s(\S+)/)
			headerToken = matches[1]
		else
			headerToken = undefined

	bearerToken = headerToken or getToken

	if not bearerToken?
		# console.log 'token not found'.red
		return

	# console.log 'bearerToken', bearerToken

	getAccessToken = Meteor.wrapAsync oauth2server.oauth.model.getAccessToken, oauth2server.oauth.model
	accessToken = getAccessToken bearerToken

	if not accessToken?
		# console.log 'accessToken not found'.red
		return

	if accessToken.expires? and accessToken.expires isnt 0 and accessToken.expires < new Date()
		# console.log 'accessToken expired'.red
		return

	user = CaoLiao.models.Users.findOne(accessToken.userId)
	if not user?
		# console.log 'user not found'.red
		return

	return user: user

