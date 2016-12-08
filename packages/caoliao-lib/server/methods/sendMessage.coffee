Meteor.methods
	sendMessage: (message) ->
		if message.msg?.length > CaoLiao.settings.get('Message_MaxAllowedSize')
			throw new Meteor.Error('error-message-size-exceeded', 'Message size exceeds Message_MaxAllowedSize', { method: 'sendMessage' })

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'sendMessage' })

		user = CaoLiao.models.Users.findOneById Meteor.userId(), fields: username: 1

		room = Meteor.call 'canAccessRoom', message.rid, user._id

		if not room
			return false

		if user.username in (room.muted or [])
			CaoLiao.Notifications.notifyUser Meteor.userId(), 'message', {
				_id: Random.id()
				rid: room._id
				ts: new Date
				msg: TAPi18n.__('You_have_been_muted', {}, user.language);
			}
			return false

		CaoLiao.sendMessage user, message, room

# Limit a user to sending 5 msgs/second
# DDPRateLimiter.addRule
# 	type: 'method'
# 	name: 'sendMessage'
# 	userId: (userId) ->
# 		return CaoLiao.models.Users.findOneById(userId)?.username isnt CaoLiao.settings.get('InternalHubot_Username')
# , 5, 1000
