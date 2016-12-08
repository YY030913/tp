Meteor.startup ->
	Meteor.setTimeout ->
		if CaoLiao.Info?.version
			msg = [
				"Version: #{CaoLiao.Info.version}"
				"Process Port: #{process.env.PORT}"
				"Site URL: #{CaoLiao.settings.get('Site_Url')}"
			].join('\n')

			SystemLogger.startup_box msg, 'SERVER RUNNING'
	, 100
