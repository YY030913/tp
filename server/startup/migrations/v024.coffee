CaoLiao.Migrations.add
	version: 24
	up: ->
		CaoLiao.models.Permissions.remove({ _id: 'access-rocket-permissions' })
