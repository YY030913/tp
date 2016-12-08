Meteor.methods
	setUsername: (username) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setUsername' })

		user = Meteor.user()

		if user.username? and not CaoLiao.settings.get("Accounts_AllowUsernameChange")
			throw new Meteor.Error('error-not-allowed', "Not allowed", { method: 'setUsername' })

		if user.username is username
			return username

		###
		try
			nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test username
			throw new Meteor.Error 'username-invalid', "#{username} is not a valid username, use only letters, numbers, dots, hyphens and underscores"
		###

		if username.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || username.length < CaoLiao.settings.get('UTF8_Names_MinLength')
			throw new Meteor.Error 'username-invalid-length', "#{username} is not a valid length must longer then #{CaoLiao.settings.get('UTF8_Names_MinLength')} and litter then #{CaoLiao.settings.get('UTF8_Names_MaxLength')}"

		if user.username != undefined
			if not username.toLowerCase() == user.username.toLowerCase()
				if not  CaoLiao.checkUsernameAvailability username
					throw new Meteor.Error 'error-field-unavailable', "<strong>" + username + "</strong> is already in use :(", { method: 'setUsername', field: username }
		else
			if not  CaoLiao.checkUsernameAvailability username
				throw new Meteor.Error 'error-field-unavailable', "<strong>" + username + "</strong> is already in use :(", { method: 'setUsername', field: username }

		unless CaoLiao.setUsername user._id, username
			throw new Meteor.Error 'error-could-not-change-username', "Could not change username", { method: 'setUsername' }

		_.each(CaoLiao.models.Tags.find({t: 'o'}, {fields: {_id: 1, name: 1, ts: 1, t: 1}}).fetch(), (element, index, list)->
			ds = CaoLiao.models.DebateSubscriptions.findOneByTagIdAndUserId element._id, user._id
			if !ds?
				CaoLiao.models.DebateSubscriptions.createWithTagAndUser element, {_id: user._id, username: username}
		)


		activity = CaoLiao.Activity.utils.add('Username_title', null, 'register', 'register', null)
		activity.userId = this.userId
		CaoLiao.models.Activity.createActivity(activity)

		return username

CaoLiao.RateLimiter.limitMethod 'setUsername', 1, 1000,
	userId: (userId) -> return true
