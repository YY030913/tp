Meteor.methods({
	'livechat:removeCustomField'(_id) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeCustomField' });
		}

		check(_id, String);

		var customField = CaoLiao.models.LivechatCustomField.findOneById(_id, { fields: { _id: 1 } });

		if (!customField) {
			throw new Meteor.Error('error-invalid-custom-field', 'Custom field not found', { method: 'livechat:removeCustomField' });
		}

		return CaoLiao.models.LivechatCustomField.removeById(_id);
	}
});
