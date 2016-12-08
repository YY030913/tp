CaoLiao.Migrations.add({
	version: 51,
	up: function() {
		CaoLiao.models.Rooms.find({ t: 'l', 'v.token': { $exists: true }, label: { $exists: false }}).forEach(function(room) {
			var user = CaoLiao.models.Users.findOne({ 'profile.token': room.v.token });
			if (user) {
				CaoLiao.models.Rooms.update({ _id: room._id }, {
					$set: {
						label: user.name || user.username,
						'v._id': user._id
					}
				});
				CaoLiao.models.Subscriptions.update({ rid: room._id }, {
					$set: {
						name: user.name || user.username
					}
				}, { multi: true });
			}
		});
	}
});
