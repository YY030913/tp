Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'view-user-profile')?
		CaoLiao.models.Permissions.upsert( 'view-user-profile', { $setOnInsert : { _id: 'view-user-profile', roles : ['admin', 'user', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-follow')?
		CaoLiao.models.Permissions.upsert( 'update-follow', { $setOnInsert : { _id: 'update-follow', roles : ['admin', 'user', 'owner'] } })


	CaoLiao.settings.addGroup('Profile');
	CaoLiao.settings.add('User_Profile_Enabled', true, { type: 'boolean', group: 'Profile', i18nLabel: 'Enabled', 'public': true })