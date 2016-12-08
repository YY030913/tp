CaoLiao.Migrations.add
	version: 1
	up: ->
		CaoLiao.models.Users.find({username: {$exists: false}, lastLogin: {$exists: true}}).forEach (user) ->
			username = generateSuggestion(user)
			if username? and username.trim() isnt ''
				CaoLiao.models.Users.setUsername user._id, username
			else
				console.log "User without username", JSON.stringify(user, null, ' ')
