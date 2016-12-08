Meteor.methods
	logoutCleanUp: (user) ->
		Meteor.defer ->

			CaoLiao.callbacks.run 'afterLogoutCleanUp', user
