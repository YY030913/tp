Meteor.methods({
	getRoomRoles: function(rid) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'getRoomRoles' });
		}

		check(rid, String);

		const options = {
			sort: {
				'u.username': 1
			},
			fields: {
				rid: 1,
				u: 1,
				roles: 1
			}
		};

		const roles = CaoLiao.models.Roles.find({ scope: 'Subscriptions', description: { $exists: 1, $ne: '' } }).fetch();
		return CaoLiao.models.Subscriptions.findByRoomIdAndRoles(rid, _.pluck(roles, '_id'), options).fetch();
	}
});
