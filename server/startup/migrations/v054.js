CaoLiao.Migrations.add({
	version: 54,
	up: function() {
		CaoLiao.models.Settings.update({ _id: 'UTF8_Long_Names_And_Introduction_MaxLength'}, {
			$set: {
				value: '64'
			}
		});
	}
});
