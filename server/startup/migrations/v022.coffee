CaoLiao.Migrations.add
	version: 22
	up: ->
		###
		# Update message edit field
		###

		CaoLiao.models.Messages.upgradeEtsToEditAt()
		console.log 'Updated old messages\' ets edited timestamp to new editedAt timestamp.'
