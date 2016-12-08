CaoLiao.Migrations.add
	version: 11
	up: ->
		###
		# Set GENERAL room to be default
		###

		CaoLiao.models.Rooms.update({_id: 'GENERAL'}, {$set: {default: true}})
		console.log "Set GENERAL room to be default"
