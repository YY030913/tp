Meteor.startup(() => {
	CaoLiao.roomTypes.setPublish('l', (code) => {
		return CaoLiao.models.Rooms.findLivechatByCode(code, {
			name: 1,
			t: 1,
			cl: 1,
			u: 1,
			label: 1,
			usernames: 1,
			v: 1,
			livechatData: 1,
			topic: 1,
			tags: 1,
			sms: 1,
			code: 1,
			open: 1
		});
	});

	CaoLiao.authz.addRoomAccessValidator(function(room, user) {
		return room.t === 'l' && CaoLiao.authz.hasPermission(user._id, 'view-livechat-rooms');
	});

	CaoLiao.callbacks.add('beforeLeaveRoom', function(user, room) {
		if (room.t !== 'l') {
			return user;
		}
		throw new Meteor.Error(TAPi18n.__('You_cant_leave_a_livechat_room_Please_use_the_close_button', {
			lng: user.language || CaoLiao.settings.get('language') || 'en'
		}));
	}, CaoLiao.callbacks.priority.LOW);
});
