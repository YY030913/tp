CaoLiao.models.MRStatistics = new class extends CaoLiao.models._Base
	constructor: ->
		@_initModel 'mr_statistics'


	# FIND ONE
	findOneById: (_id, options) ->
		query =
			_id: _id

		return @findOne query, options
