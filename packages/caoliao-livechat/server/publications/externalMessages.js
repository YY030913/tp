Meteor.publish('livechat:externalMessages', function(roomId) {
	return CaoLiao.models.LivechatExternalMessage.findByRoomId(roomId);
});
