Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'view-user-friend')?
		CaoLiao.models.Permissions.upsert( 'view-user-friend', { $setOnInsert : { _id: 'view-user-friend', roles : ['admin', 'user'] } })

	CaoLiao.settings.addGroup('Friend');

	CaoLiao.settings.add('User_Friend_Enabled', true, { type: 'boolean', group: 'Friend', i18nLabel: 'Enabled' });