CaoLiao.Migrations.add({
	version: 44,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Users) {
			CaoLiao.models.Users.find({ $or: [ { 'settings.preferences.disableNewRoomNotification': { $exists: 1 } }, { 'settings.preferences.disableNewMessageNotification': { $exists: 1 } } ] }).forEach(function(user) {
				var newRoomNotification = !(user && user.settings && user.settings.preferences && user.settings.preferences.disableNewRoomNotification);
				var newMessageNotification = !(user && user.settings && user.settings.preferences && user.settings.preferences.disableNewMessageNotification);
				CaoLiao.models.Users.update({ _id: user._id }, { $unset: { 'settings.preferences.disableNewRoomNotification': 1, 'settings.preferences.disableNewMessageNotification': 1 }, $set: { 'settings.preferences.newRoomNotification': newRoomNotification, 'settings.preferences.newMessageNotification': newMessageNotification } });
			});
		}

		if (CaoLiao && CaoLiao.models && CaoLiao.models.Settings) {
			var optOut = CaoLiao.models.Settings.findOne({ _id: 'Statistics_opt_out' });
			if (optOut) {
				CaoLiao.models.Settings.remove({ _id: 'Statistics_opt_out' });
				CaoLiao.models.Settings.upsert({ _id: 'Statistics_reporting' }, {
					$set: {
						value: !optOut.value ? true : false,
						i18nDescription: 'Statistics_reporting_Description',
						packageValue: true,
						i18nLabel: 'Statistics_reporting'
					}
				});
			}
		}

		if (CaoLiao && CaoLiao.models && CaoLiao.models.Settings) {
			var favoriteRooms = CaoLiao.models.Settings.findOne({ _id: 'Disable_Favorite_Rooms' });
			if (favoriteRooms) {
				CaoLiao.models.Settings.remove({ _id: 'Disable_Favorite_Rooms' });
				CaoLiao.models.Settings.upsert({ _id: 'Favorite_Rooms' }, {
					$set: {
						value: !favoriteRooms.value ? true : false,
						i18nDescription: 'Favorite_Rooms_Description',
						packageValue: true,
						i18nLabel: 'Favorite_Rooms'
					}
				});
			}
		}
	}
});
