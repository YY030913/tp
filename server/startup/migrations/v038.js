CaoLiao.Migrations.add({
	version: 38,
	up: function() {
		if (CaoLiao && CaoLiao.settings && CaoLiao.settings.get) {
			var allowPinning = CaoLiao.settings.get('Message_AllowPinningByAnyone');

			// If public pinning was allowed, add pinning permissions to 'users', else leave it to 'owners' and 'moderators'
			if (allowPinning) {
				if (CaoLiao.models && CaoLiao.models.Permissions) {
					CaoLiao.models.Permissions.update({ _id: 'pin-message' }, { $addToSet: { roles: 'user' } });
				}
			}
		}
	}
});
