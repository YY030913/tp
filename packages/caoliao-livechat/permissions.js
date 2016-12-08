Meteor.startup(() => {
	var roles = _.pluck(CaoLiao.models.Roles.find().fetch(), 'name');
	if (roles.indexOf('livechat-agent') === -1) {
		CaoLiao.models.Roles.createOrUpdate('livechat-agent');
	}
	if (roles.indexOf('livechat-manager') === -1) {
		CaoLiao.models.Roles.createOrUpdate('livechat-manager');
	}
	if (roles.indexOf('livechat-guest') === -1) {
		CaoLiao.models.Roles.createOrUpdate('livechat-guest');
	}
	if (CaoLiao.models && CaoLiao.models.Permissions) {
		CaoLiao.models.Permissions.createOrUpdate('view-l-room', ['livechat-agent', 'livechat-manager', 'admin']);
		CaoLiao.models.Permissions.createOrUpdate('view-livechat-manager', ['livechat-manager', 'admin']);
		CaoLiao.models.Permissions.createOrUpdate('view-livechat-rooms', ['livechat-manager', 'admin']);
		CaoLiao.models.Permissions.createOrUpdate('close-livechat-room', ['livechat-agent', 'livechat-manager', 'admin']);
		CaoLiao.models.Permissions.createOrUpdate('close-others-livechat-room', ['livechat-manager', 'admin']);
	}
});
