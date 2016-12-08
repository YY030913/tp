Meteor.publish 'channelAutocomplete', (name) ->
	unless this.userId
		return this.ready()

	pub = this

	options =
		fields:
			_id: 1
			name: 1
		limit: 5
		sort:
			name: 1

	roomIds = []
	if not CaoLiao.authz.hasPermission(this.userId, 'view-c-room') and CaoLiao.authz.hasPermission(this.userId, 'view-joined-room')
		roomIds = _.pluck CaoLiao.models.Subscriptions.findByUserId(this.userId).fetch(), 'rid'

	hasPermission = (_id) =>
		return CaoLiao.authz.hasPermission(this.userId, 'view-c-room') or (CaoLiao.authz.hasPermission(this.userId, 'view-joined-room') and roomIds.indexOf(_id) isnt -1)

	cursorHandle = CaoLiao.models.Rooms.findByNameContainingAndTypes(name, ['c'], options).observeChanges
		added: (_id, record) ->
			if hasPermission(_id)
				pub.added('channel-autocomplete', _id, record)
		changed: (_id, record) ->
			if hasPermission(_id)
				pub.changed('channel-autocomplete', _id, record)
		removed: (_id, record) ->
			if hasPermission(_id)
				pub.removed('channel-autocomplete', _id, record)

	@ready()
	@onStop ->
		cursorHandle.stop()
	return
