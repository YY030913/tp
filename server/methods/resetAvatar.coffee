Meteor.methods
	resetAvatar: (image, service) ->
		unless Meteor.userId()
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'resetAvatar' });

		unless CaoLiao.settings.get("Accounts_AllowUserAvatarChange")
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'resetAvatar' });

		user = Meteor.user()

		CaoLiaoFileAvatarInstance.deleteFile "#{user.username}.jpg"

		CaoLiao.models.Users.unsetAvatarOrigin user._id

		CaoLiao.Notifications.notifyAll 'updateAvatar', {username: user.username}
		return

# Limit changing avatar once per minute
DDPRateLimiter.addRule
	type: 'method'
	name: 'resetAvatar'
	userId: -> return true
, 1, 60000
