@tagStream = new Meteor.Streamer 'tag-debates'

tagStream.allowWrite('none')


tagStream.allowRead (eventName) ->
	#console.log('stream.permissions.read', this.userId, eventName);
	# return this.userId == eventName;

	try
		canAccess = Meteor.call 'canAccessTag', eventName, this.userId

		return false if not canAccess

		return true
	catch e
		return false


Meteor.startup ->
	options = {}

	CaoLiao.models.Debates.findVisibleCreatedOrEditedAfterTimestamp(new Date(), options).observe
		added: (record) ->
			_.each(record.tags, (element, index, list)->
				tagStream.emit element._id, record
			)
			

		changed: (record) ->
			_.each(record.tags, (element, index, list)->
				tagStream.emit element._id, record
			)
