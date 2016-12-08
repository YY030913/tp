Meteor.methods
	joinTag: (_id) ->
		user = Meteor.user()
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'joinTag' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'join-tag') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'joinTag' }

		

		tag = CaoLiao.models.Tags.findOne {_id: _id}
		
		tagSubscription = CaoLiao.models.DebateSubscriptions.findOne {name: tag.name}


		if tag? and tagSubscription?
			CaoLiao.models.Tags.pushMember tag._id, {_id: user._id, username: user.username}
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser tag, {_id: user._id, username: user.username}

		return true