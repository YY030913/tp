CaoLiao.Migrations.add({
	version: 49,
	up: function() {

		var count = 1;

		CaoLiao.models.Rooms.find({ t: 'l' }, { sort: { ts: 1 }, fields: { _id: 1 } }).forEach(function(room) {
			CaoLiao.models.Rooms.update({ _id: room._id }, { $set: { code: count } });
			CaoLiao.models.Subscriptions.update({ rid: room._id }, { $set: { code: count } }, { multi: true });
			count++;
		});

		CaoLiao.models.Settings.upsert({ _id: 'Livechat_Room_Count' }, {
			$set: {
				value: count,
				type: 'int',
				group: 'Livechat'
			}
		});
	}
});
