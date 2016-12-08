CaoLiao.Migrations.add
	version: 16
	up: ->
		CaoLiao.models.Messages.tryDropIndex({ _hidden: 1 })
