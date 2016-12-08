Meteor.methods
	getStatistics: (refresh) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'getStatistics' })

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'view-statistics') is true
			throw new Meteor.Error('error-not-allowed', "Not allowed", { method: 'getStatistics' })

		if refresh
			return CaoLiao.statistics.save()
		else
			return CaoLiao.models.Statistics.findLast()

