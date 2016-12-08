Meteor.methods({
	'livechat:setCustomField'(token, key, value) {
		const customField = CaoLiao.models.LivechatCustomField.findOneById(key);
		if (customField) {
			if (customField.scope === 'room') {
				return CaoLiao.models.Rooms.updateLivechatDataByToken(token, key, value);
			} else {
				// Save in user
				return CaoLiao.models.Users.updateLivechatDataByToken(token, key, value);
			}
		}

		return true;
	}
});
