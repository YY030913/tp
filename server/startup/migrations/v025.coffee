CaoLiao.Migrations.add
	version: 25
	up: ->
		CaoLiao.models.Settings.update({ _id: /Accounts_OAuth_Custom/ }, { $set: { persistent: true }, $unset: {hidden: true} }, { multi: true })
