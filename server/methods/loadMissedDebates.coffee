Meteor.methods
	loadMissedDebates: (tid, start) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'loadMissedDebates' }

		fromId = Meteor.userId()
		unless Meteor.call 'canAccessFlag', tid, fromId
			return false

		options =
			sort:
				ts: -1

		#if not CaoLiao.settings.get 'Message_ShowEditedStatus'
		#	options.fields = { 'editedAt': 0 }

		return CaoLiao.models.Debates.findVisibleByFlagIdAfterTimestamp(tid, start, options).fetch()
