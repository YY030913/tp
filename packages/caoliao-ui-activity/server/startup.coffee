Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'view-user-activity')?
		CaoLiao.models.Permissions.upsert( 'view-user-activity', { $setOnInsert : { _id: 'view-user-activity', roles : ['admin', 'user'] } })

	CaoLiao.settings.addGroup('Activity');

	CaoLiao.settings.add('User_Activity_Enabled', true, { type: 'boolean', group: 'Activity', i18nLabel: 'Enabled' })
	