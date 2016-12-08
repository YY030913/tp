Meteor.publish('livechat:visitorPageVisited', function({ rid: roomId }) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorPageVisited' }));
	}

	if (!CaoLiao.authz.hasPermission(this.userId, 'view-livechat-rooms')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorPageVisited' }));
	}

	var room = CaoLiao.models.Rooms.findOneById(roomId);

	if (room && room.v && room.v.token) {
		return CaoLiao.models.LivechatPageVisited.findByToken(room.v.token);
	} else {
		return this.ready();
	}
});
