Meteor.startup ->
	CaoLiao.settings.onload 'Force_SSL', (key, value) ->
		Meteor.absoluteUrl.defaultOptions.secure = value
