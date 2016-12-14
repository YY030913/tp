Meteor.methods
	saveUserProfile: (settings) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'saveUserProfile' }

		user = CaoLiao.models.Users.findOneById Meteor.userId()

		if s.trim(user?.services?.password?.bcrypt) and not settings.currentPassword
			throw new Meteor.Error('error-invalid-password', 'Invalid password', { method: 'saveUserProfile' })

		unless CaoLiao.settings.get("Accounts_AllowUserProfileChange")
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'saveUserProfile' })

		if s.trim(user?.services?.password?.bcrypt)
			passCheck = Accounts._checkPassword(user, { digest: settings.currentPassword, algorithm: 'sha-256' });
			if passCheck.error
				throw new Meteor.Error('error-invalid-password', 'Invalid password', { method: 'saveUserProfile' });

		if settings.newPassword?
			Accounts.setPassword Meteor.userId(), settings.newPassword, { logout: false }

		if settings.realname?
			Meteor.call 'setRealName', settings.realname

		if settings.username?
			Meteor.call 'setUsername', settings.username

		console.log "settings",settings
		if settings.email?
			Meteor.call 'setEmail', settings.email

		if settings.introduction?
			Meteor.call 'setIntroduction', settings.introduction

		profile = {}

		CaoLiao.models.Users.setProfile Meteor.userId(), profile

		return true
