Meteor.methods({
	'livechat:removeDepartment'(_id) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeDepartment' });
		}

		check(_id, String);

		var department = CaoLiao.models.LivechatDepartment.findOneById(_id, { fields: { _id: 1 } });

		if (!department) {
			throw new Meteor.Error('department-not-found', 'Department not found', { method: 'livechat:removeDepartment' });
		}

		return CaoLiao.models.LivechatDepartment.removeById(_id);
	}
});
