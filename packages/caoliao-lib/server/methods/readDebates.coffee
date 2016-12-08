Meteor.methods
	readDebates: (fid) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'readDebates' }

		CaoLiao.models.DebateSubscriptions.setAsReadByFlagIdAndUserId fid, Meteor.userId()
