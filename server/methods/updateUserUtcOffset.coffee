Meteor.methods
	updateUserUtcOffset: (utcOffset) ->
		if not @userId?
			return

		@unblock()

		CaoLiao.models.Users.setUtcOffset @userId, utcOffset

DDPRateLimiter.addRule
	type: 'method'
	name: 'updateUserUtcOffset'
	userId: -> return true
, 1, 60000
