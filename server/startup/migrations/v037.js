CaoLiao.Migrations.add({
	version: 37,
	up: function() {
		if (CaoLiao && CaoLiao.models && CaoLiao.models.Permissions) {

			// Find permission add-user (changed it to create-user)
			var addUserPermission = CaoLiao.models.Permissions.findOne('add-user');

			if (addUserPermission) {
				CaoLiao.models.Permissions.upsert({ _id: 'create-user' }, { $set: { roles: addUserPermission.roles } });
				CaoLiao.models.Permissions.remove({ _id: 'add-user' });
			}
		}
	}
});
