Meteor.methods
	loginSuccess: () ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'loginSuccess' }

		activity = CaoLiao.Activity.utils.add('Login', null, 'login', 'login', null)
		activity.userId = Meteor.userId()
		CaoLiao.models.Activity.createActivity(activity)