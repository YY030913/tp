CaoLiao.Migrations.add
	version: 13
	up: ->
		# Set all current users as active
		CaoLiao.models.Users.setAllUsersActive true
		console.log "Set all users as active"
