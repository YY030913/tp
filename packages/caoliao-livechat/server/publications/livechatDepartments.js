Meteor.publish('livechat:departments', function(_id) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:agents' }));
	}

	if (!CaoLiao.authz.hasPermission(this.userId, 'view-livechat-rooms')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:agents' }));
	}

	if (_id !== undefined) {
		return CaoLiao.models.LivechatDepartment.findByDepartmentId(_id);
	} else {
		return CaoLiao.models.LivechatDepartment.find();
	}

});
