CaoLiao.Migrations.add
	version: 17
	up: ->
		CaoLiao.models.Messages.tryDropIndex({ _hidden: 1 })
