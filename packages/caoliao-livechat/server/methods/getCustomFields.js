Meteor.methods({
	'livechat:getCustomFields'() {
		return CaoLiao.models.LivechatCustomField.find().fetch();
	}
});
