Meteor.methods({
	'livechat:removeManager'(username) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeManager' });
		}

		check(username, String);

		var user = CaoLiao.models.Users.findOneByUsername(username, { fields: { _id: 1 } });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'livechat:removeManager' });
		}

		return CaoLiao.authz.removeUserFromRoles(user._id, 'livechat-manager');
	}
});
