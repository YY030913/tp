Meteor.publish 'debate', (slug) ->
	unless this.userId
		return this.ready()

	publication = @

	if CaoLiao.authz.hasPermission( @userId, 'view-debate')
		cursorHandle = CaoLiao.models.Debates.findList({
			_id: slug
		}, { 
			sort: { 
				ts: -1 
			}, 
			fields: {
				_id :1
				name: 1
				u: 1
				ts: 1
				htmlBody: 1
				tags: 1
				readCount: 1
				shareCount: 1
				txt: 1
				rid: 1
				save: 1
				debateType: 1
				webrtcJoined: 1
			}
		}).observeChanges
			added: (_id, record) ->
				publication.added('caoliao_debate_pub', _id, record)

			changed: (_id, record) ->
				publication.changed('caoliao_debate_pub', _id, record)

			removed: (_id) ->
				publication.removed('caoliao_debate_pub', _id)

	@ready()