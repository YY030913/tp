CaoLiao.Migrations.add
	version: 2
	up: ->
		CaoLiao.models.Users.find({avatarOrigin: {$exists: false}, username: {$exists: true}}).forEach (user) ->
			avatars = getAvatarSuggestionForUser user

			services = Object.keys avatars

			if services.length is 0
				return

			service = services[0]
			console.log user.username, '->', service

			dataURI = avatars[service].blob

			{image, contentType} = CaoLiaoFile.dataURIParse dataURI

			rs = CaoLiaoFile.bufferToStream new Buffer(image, 'base64')
			ws = CaoLiaoFileAvatarInstance.createWriteStream "#{user.username}.jpg", contentType
			ws.on 'end', Meteor.bindEnvironment ->
				CaoLiao.models.Users.setAvatarOrigin user._id, service

			rs.pipe(ws)
