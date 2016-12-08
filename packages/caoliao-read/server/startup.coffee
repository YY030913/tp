Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'view-user-read')?
		CaoLiao.models.Permissions.upsert( 'view-user-read', { $setOnInsert : { _id: 'view-user-read', roles : ['admin', 'owner'] } })

	CaoLiao.settings.addGroup('Read');

	CaoLiao.settings.add('View_User_Read_Enabled', true, { type: 'boolean', group: 'Read', i18nLabel: 'Enabled' })
	