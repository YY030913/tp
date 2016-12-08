CaoLiao.Migrations.add({
	version: 41,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Users) {
			CaoLiao.models.Users.update({ bot: true }, { $set: { type: 'bot' } }, { multi: true });
			CaoLiao.models.Users.update({ 'profile.guest': true }, { $set: { type: 'visitor' } }, { multi: true });
			CaoLiao.models.Users.update({ type: { $exists: false } }, { $set: { type: 'user' } }, { multi: true });
		}
	}
});
