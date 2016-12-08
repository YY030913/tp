Meteor.methods({
	'livechat:saveTrigger'(trigger) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:saveTrigger' });
		}

		return CaoLiao.models.LivechatTrigger.save(trigger);
	}
});
