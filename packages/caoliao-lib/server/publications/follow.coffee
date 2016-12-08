Meteor.publish 'follow', (slug) ->
	unless this.userId
		return this.ready()

	publication = @

	if CaoLiao.authz.hasPermission( @userId, 'view-user-profile')
		cursorHandle = CaoLiao.models.Friend.findByUser(slug, { 
			sort: { 
				ts: -1 
			},
			fields: {
				_id: 1
				friend: 1
				pinyin: 1
				u: 1
				ts: 1
				del: 1
			}
		}).observeChanges
			added: (_id, record) ->
				publication.added('caoliao_follow', _id, record)

			changed: (_id, record) ->
				publication.changed('caoliao_follow', _id, record)

			removed: (_id) ->
				publication.removed('caoliao_follow', _id)

		cursorHandleFriend = CaoLiao.models.Friend.findByFriend(slug, { 
			sort: { 
				ts: -1 
			}, 
			fields: {
				_id: 1
				friend: 1
				pinyin: 1
				u: 1
				ts: 1
				del: 1
			}
		}).observeChanges
			added: (_id, record) ->
				publication.added('caoliao_follow', _id, record)

			changed: (_id, record) ->
				publication.changed('caoliao_follow', _id, record)

			removed: (_id) ->
				publication.removed('caoliao_follow', _id)

	@ready()