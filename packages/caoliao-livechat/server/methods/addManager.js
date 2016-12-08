Meteor.methods({
	'livechat:addManager'(username) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:addManager' });
		}

		if (!username || !_.isString(username)) {
			throw new Meteor.Error('error-invalid-arguments', 'Invalid arguments', { method: 'livechat:addManager' });
		}

		var user = CaoLiao.models.Users.findOneByUsername(username, { fields: { _id: 1 } });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'livechat:addManager' });
		}

		return CaoLiao.authz.addUserRoles(user._id, 'livechat-manager');
	}
});
