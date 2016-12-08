Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'view-user-score')?
		CaoLiao.models.Permissions.upsert( 'view-user-score', { $setOnInsert : { _id: 'view-user-score', roles : ['admin', 'user'] } })

	CaoLiao.settings.addGroup('Score');

	CaoLiao.settings.add('User_Score_Enabled', true, { type: 'boolean', group: 'Score', i18nLabel: 'Enabled' });