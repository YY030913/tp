CaoLiao.Migrations.add({
	version: 52,
	up: function() {
		CaoLiao.models.Users.update({ _id: 'rocket.cat' }, { $addToSet: { roles: 'bot' } });
	}
});
