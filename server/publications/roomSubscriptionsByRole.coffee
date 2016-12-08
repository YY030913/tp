Meteor.publish 'roomSubscriptionsByRole', (rid, role) ->
	unless this.userId
		return this.ready()

	if CaoLiao.authz.hasPermission( @userId, 'view-other-user-channels') isnt true
		return this.ready()

	CaoLiao.models.Subscriptions.findByRoomIdAndRoles rid, role,
		fields:
			rid: 1,
			name: 1,
			roles: 1,
			u: 1
		sort: { name: 1 }
