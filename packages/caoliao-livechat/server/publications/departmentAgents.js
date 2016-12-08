Meteor.publish('livechat:departmentAgents', function(departmentId) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:departmentAgents' }));
	}

	if (!CaoLiao.authz.hasPermission(this.userId, 'view-livechat-rooms')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:departmentAgents' }));
	}

	return CaoLiao.models.LivechatDepartmentAgents.find({ departmentId: departmentId });
});
