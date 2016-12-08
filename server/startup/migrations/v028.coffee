CaoLiao.Migrations.add
	version: 28
	up: ->
		CaoLiao.models.Permissions.addRole 'view-c-room', 'bot'
