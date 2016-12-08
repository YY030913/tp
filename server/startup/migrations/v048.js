CaoLiao.Migrations.add({
	version: 48,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Settings) {

			var RocketBot_Enabled = CaoLiao.models.Settings.findOne({
				_id: 'RocketBot_Enabled'
			});
			if (RocketBot_Enabled) {
				CaoLiao.models.Settings.remove({
					_id: 'RocketBot_Enabled'
				});
				CaoLiao.models.Settings.upsert({
					_id: 'InternalHubot_Enabled'
				}, {
					$set: {
						value: RocketBot_Enabled.value
					}
				});
			}

			var RocketBot_Name = CaoLiao.models.Settings.findOne({
				_id: 'RocketBot_Name'
			});
			if (RocketBot_Name) {
				CaoLiao.models.Settings.remove({
					_id: 'RocketBot_Name'
				});
				CaoLiao.models.Settings.upsert({
					_id: 'InternalHubot_Username'
				}, {
					$set: {
						value: RocketBot_Name.value
					}
				});
			}

		}
	}
});
