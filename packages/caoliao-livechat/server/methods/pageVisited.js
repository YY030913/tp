Meteor.methods({
	'livechat:pageVisited'(token, pageInfo) {
		return CaoLiao.models.LivechatPageVisited.saveByToken(token, pageInfo);
	}
});
