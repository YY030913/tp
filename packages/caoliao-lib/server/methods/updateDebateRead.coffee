Meteor.methods
	updateDebateRead: (_id) ->
		user = Meteor.user()
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateRead' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'update-debate-read') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateRead' }

		debate = CaoLiao.models.Debates.findOne {_id: _id}
		if debate?
			CaoLiao.models.Debates.pushReadById _id, {_id: user._id, username: user.username}

			if CaoLiao.models.Debates.find(_id, {"read._id": user._id}).count()==0
				CaoLiao.models.Debates.incReadCount _id

		return true