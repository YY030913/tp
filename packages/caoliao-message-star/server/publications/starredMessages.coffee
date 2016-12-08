Meteor.publish 'starredMessages', (rid, limit=50) ->
	unless this.userId
		return this.ready()

	publication = @

	user = CaoLiao.models.Users.findOneById this.userId
	unless user
		return this.ready()

	cursorHandle = CaoLiao.models.Messages.findStarredByUserAtRoom(this.userId, rid, { sort: { ts: -1 }, limit: limit }).observeChanges
		added: (_id, record) ->
			publication.added('caoliao_starred_message', _id, record)

		changed: (_id, record) ->
			publication.changed('caoliao_starred_message', _id, record)

		removed: (_id) ->
			publication.removed('caoliao_starred_message', _id)

	@ready()
	@onStop ->
		cursorHandle.stop()
