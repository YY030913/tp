CaoLiao.models.Activity = new class extends CaoLiao.models._Base
	constructor: ->
		@_initModel 'activity'

	# FIND
	findByUser: (userId, options) ->
		query =
			userId: userId
			del: {
				$ne: true
			}

		return @find query, options


	# INSERT
	createActivity: (option) ->
		record = {
			ts: new Date()
			del: false
		}
		record = _.extend record, option

		return @insert record
