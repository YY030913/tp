Meteor.methods
	loadNextDebates: (tid, end, limit=20) ->
		console.log "loadNextDebates",arguments
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'loadNextDebates' }

		fromId = Meteor.userId()

		unless Meteor.call 'canAccessFlag', tid, fromId
			return false

		options =
			sort:
				ts: -1
			limit: limit

		#if not CaoLiao.settings.get 'Message_ShowEditedStatus'
		#	options.fields = { 'editedAt': 0 }

		if end?
			records = CaoLiao.models.Debates.findVisibleByFlagIdAfterTimestamp(tid, end, options).fetch()
		else
			records = CaoLiao.models.Debates.findVisibleByFlagId(tid, options).fetch()

		debates = _.map records, (debate) ->
			debate.starred = _.findWhere debate.starred, { _id: fromId }
			return debate

		return {
			debates: debates
		}
