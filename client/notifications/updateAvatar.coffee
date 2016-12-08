Meteor.startup ->
	CaoLiao.Notifications.onAll 'updateAvatar', (data) ->
		updateAvatarOfUsername data.username
