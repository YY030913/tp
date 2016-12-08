CaoLiao.settings.onload 'CDN_PREFIX', (key, value, initialLoad) ->
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value

Meteor.startup ->
	value = CaoLiao.settings.get 'CDN_PREFIX'
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value
