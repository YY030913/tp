CaoLiao.Migrations.add({
	version: 43,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Permissions) {
			CaoLiao.models.Permissions.update({ _id: 'pin-message' }, { $addToSet: { roles: 'admin' } });
		}
	}
});
