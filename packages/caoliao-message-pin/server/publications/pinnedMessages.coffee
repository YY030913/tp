Meteor.publish 'pinnedMessages', (rid, limit=50) ->
	unless this.userId
		return this.ready()

	publication = @

	user = CaoLiao.models.Users.findOneById this.userId
	unless user
		return this.ready()

	cursorHandle = CaoLiao.models.Messages.findPinnedByRoom(rid, { sort: { ts: -1 }, limit: limit }).observeChanges
		added: (_id, record) ->
			publication.added('caoliao_pinned_message', _id, record)

		changed: (_id, record) ->
			publication.changed('caoliao_pinned_message', _id, record)

		removed: (_id) ->
			publication.removed('caoliao_pinned_message', _id)

	@ready()
	@onStop ->
		cursorHandle.stop()
