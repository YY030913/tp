CaoLiao.Migrations.add
	version: 26
	up: ->
		CaoLiao.models.Messages.update({ t: 'rm' }, { $set: { mentions: [] } }, { multi: true })
