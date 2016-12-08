Meteor.publish('livechat:visitorInfo', function({ rid: roomId }) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorInfo' }));
	}

	if (!CaoLiao.authz.hasPermission(this.userId, 'view-livechat-rooms')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorInfo' }));
	}

	var room = CaoLiao.models.Rooms.findOneById(roomId);

	if (room && room.v && room.v._id) {
		return CaoLiao.models.Users.findById(room.v._id);
	} else {
		return this.ready();
	}
});
