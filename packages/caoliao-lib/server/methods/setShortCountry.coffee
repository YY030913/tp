Meteor.methods
	setShortCountry: (shorCountry) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setShortCountry' })

		user = Meteor.user()

		if user.shorCountry? and not CaoLiao.settings.get("Accounts_AllowshorCountryChange")
			throw new Meteor.Error('error-not-allowed', "Not allowed", { method: 'setShortCountry' })

		if user.shorCountry is shorCountry
			return shorCountry

		if shorCountry.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || shorCountry.length < CaoLiao.settings.get('UTF8_Names_MinLength')
			throw new Meteor.Error 'shorCountry-invalid-length', "#{shorCountry} is not a valid length must longer then #{CaoLiao.settings.get('UTF8_Names_MinLength')} and litter then #{CaoLiao.settings.get('UTF8_Names_MaxLength')}"

		CaoLiao.models.Users.setShortCountry this.userId, shorCountry

		###
		unless CaoLiao.setShortCountry user._id, shorCountry
			throw new Meteor.Error 'error-could-not-change-shorCountry', "Could not change shorCountry", { method: 'setShortCountry' }
		

		activity = CaoLiao.Activity.utils.add('ShorCountry', null, 'changeShortCountry', 'changeShortCountry', null)
		activity.userId = this.userId
		CaoLiao.models.Activity.createActivity(activity)
		###

		return shorCountry

CaoLiao.RateLimiter.limitMethod 'setShortCountry', 1, 1000,
	userId: (userId) -> return true
