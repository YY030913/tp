Meteor.methods({
	'livechat:removeTrigger'(/*trigger*/) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeTrigger' });
		}

		return CaoLiao.models.LivechatTrigger.removeAll();
	}
});
