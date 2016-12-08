CaoLiao.Migrations.add({
	version: 46,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Users) {
			CaoLiao.models.Users.update({ type: { $exists: false } }, { $set: { type: 'user' } }, { multi: true });
		}
	}
});
