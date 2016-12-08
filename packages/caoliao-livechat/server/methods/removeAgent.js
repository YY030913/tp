Meteor.methods({
	'livechat:removeAgent'(username) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeAgent' });
		}

		if (!username || !_.isString(username)) {
			throw new Meteor.Error('error-invalid-arguments', 'Invalid arguments', { method: 'livechat:removeAgent' });
		}

		var user = CaoLiao.models.Users.findOneByUsername(username, { fields: { _id: 1 } });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'livechat:removeAgent' });
		}

		if (CaoLiao.authz.removeUserFromRoles(user._id, 'livechat-agent')) {
			CaoLiao.models.Users.setOperator(user._id, false);
			CaoLiao.models.Users.setLivechatStatus(user._id, 'not-available');
			return true;
		}

		return false;
	}
});
