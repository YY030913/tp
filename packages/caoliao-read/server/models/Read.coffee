CaoLiao.models.Read = new class extends CaoLiao.models._Base
	constructor: ->
		@_initModel 'read'


	# FIND
	findByUser: (userId, options) ->
		query =
			userId: userId
			del: {
				$ne: true
			}

		return @find query, options

	# PUSH
	pushReadByUserId: (userId, read) ->
		read = _.extend read, {readAt: new Date()}
		query =
			userId: userId
			del: {
				$ne: true
			}

		update =
			$push: 
				read: read

		return @update query, update

	# INSERT
	createRead: (userId, option) ->
		record = {
			userId: userId
			ts: new Date()
			del: false
		}
		record = _.extend record, option

		return @insert record
