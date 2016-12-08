buildMailURL = _.debounce ->
	console.log 'Updating process.env.MAIL_URL'
	if CaoLiao.settings.get('SMTP_Host')
		process.env.MAIL_URL = "smtp://"
		if CaoLiao.settings.get('SMTP_Username') and CaoLiao.settings.get('SMTP_Password')
			process.env.MAIL_URL += encodeURIComponent(CaoLiao.settings.get('SMTP_Username')) + ':' + encodeURIComponent(CaoLiao.settings.get('SMTP_Password')) + '@'
		process.env.MAIL_URL += encodeURIComponent(CaoLiao.settings.get('SMTP_Host'))
		if CaoLiao.settings.get('SMTP_Port')
			process.env.MAIL_URL += ':' + parseInt(CaoLiao.settings.get('SMTP_Port'))
, 500

CaoLiao.settings.onload 'SMTP_Host', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

CaoLiao.settings.onload 'SMTP_Port', (key, value, initialLoad) ->
	buildMailURL()

CaoLiao.settings.onload 'SMTP_Username', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

CaoLiao.settings.onload 'SMTP_Password', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

Meteor.startup ->
	buildMailURL()
