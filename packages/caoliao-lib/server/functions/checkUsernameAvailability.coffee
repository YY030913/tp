CaoLiao.checkUsernameAvailability = (username) ->
	return not Meteor.users.findOne({ username: { $regex : new RegExp("^" + s.trim(s.escapeRegExp(username)) + "$", "i") } })
