multer = Npm.require('multer');

CaoLiao.API.v1.addRoute 'info', authRequired: false,
	get: -> CaoLiao.Info


CaoLiao.API.v1.addRoute 'me', authRequired: true,
	get: ->
		return _.pick @user, [
			'_id'
			'name'
			'emails'
			'status'
			'statusConnection'
			'username'
			'utcOffset'
			'active'
			'language'
		]


# Send Channel Message
CaoLiao.API.v1.addRoute 'chat.messageExamples', authRequired: true,
	get: ->
		return CaoLiao.API.v1.success
			body: [
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'caoliao'
				text: 'Sample text 1'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'caoliao'
				text: 'Sample text 2'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'caoliao'
				text: 'Sample text 3'
				trigger_word: 'Sample'
			]


# Send Channel Message
CaoLiao.API.v1.addRoute 'chat.postMessage', authRequired: true,
	post: ->
		try
			messageReturn = processWebhookMessage @bodyParams, @user

			if not messageReturn?
				return CaoLiao.API.v1.failure 'unknown-error'

			return CaoLiao.API.v1.success
				ts: Date.now()
				channel: messageReturn.channel
				message: messageReturn.message
		catch e
			return CaoLiao.API.v1.failure e.error

# Set Channel Topic
CaoLiao.API.v1.addRoute 'channels.setTopic', authRequired: true,
	post: ->
		if not @bodyParams.channel?
			return CaoLiao.API.v1.failure 'Body param "channel" is required'

		if not @bodyParams.topic?
			return CaoLiao.API.v1.failure 'Body param "topic" is required'

		unless CaoLiao.authz.hasPermission(@userId, 'edit-room', @bodyParams.channel)
			return CaoLiao.API.v1.unauthorized()

		if not CaoLiao.saveRoomTopic(@bodyParams.channel, @bodyParams.topic)
			return CaoLiao.API.v1.failure 'invalid_channel'

		return CaoLiao.API.v1.success
			topic: @bodyParams.topic


# Create Channel
CaoLiao.API.v1.addRoute 'channels.create', authRequired: true,
	post: ->
		if not @bodyParams.name?
			return CaoLiao.API.v1.failure 'Body param "name" is required'

		if not CaoLiao.authz.hasPermission(@userId, 'create-c')
			return CaoLiao.API.v1.unauthorized()

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'createChannel', @bodyParams.name, []
		catch e
			return CaoLiao.API.v1.failure e.name + ': ' + e.message

		return CaoLiao.API.v1.success
			channel: CaoLiao.models.Rooms.findOne({_id: id.rid})
