/* eslint new-cap: [2, {"capIsNewExceptions": ["Match.ObjectIncluding", "Match.Optional"]}] */

Meteor.methods({
	'livechat:saveLivechatInfo': function(guestData, roomData) {
		if (!Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'view-l-room')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:saveLivechatInfo' });
		}

		check(guestData, Match.ObjectIncluding({
			_id: String,
			name: Match.Optional(String),
			email: Match.Optional(String),
			phone: Match.Optional(String)
		}));

		check(roomData, Match.ObjectIncluding({
			_id: String,
			topic: Match.Optional(String),
			tags: Match.Optional(String)
		}));

		return CaoLiao.Livechat.saveGuest(guestData) && CaoLiao.Livechat.saveRoomInfo(roomData, guestData);
	}
});
