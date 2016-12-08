Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById( 'access-debate-tag')?
		CaoLiao.models.Permissions.upsert( 'access-debate-tag', { $setOnInsert : { _id: 'access-debate-tag', roles : ['admin', 'user', 'owner'] } })
	unless CaoLiao.models.Permissions.findOneById( 'view-debate')?
		CaoLiao.models.Permissions.upsert( 'view-debate', { $setOnInsert : { _id: 'view-debate', roles : ['admin', 'user', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById( 'create-debate')?
		CaoLiao.models.Permissions.upsert( 'create-debate', { $setOnInsert : { _id: 'create-debate', roles : ['admin', 'user', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-debate')?
		CaoLiao.models.Permissions.upsert( 'update-debate', { $setOnInsert : { _id: 'update-debate', roles : ['admin', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-debate-tag')?
		CaoLiao.models.Permissions.upsert( 'update-debate-tag', { $setOnInsert : { _id: 'update-debate-tag', roles : ['admin', 'owner', 'DebateSubscriptions'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-debate-read')?
		CaoLiao.models.Permissions.upsert( 'update-debate-read', { $setOnInsert : { _id: 'update-debate-read', roles : ['admin', 'owner', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-debate-share')?
		CaoLiao.models.Permissions.upsert( 'update-debate-share', { $setOnInsert : { _id: 'update-debate-share', roles : ['admin', 'owner', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById( 'update-debate-favorite')?
		CaoLiao.models.Permissions.upsert( 'update-debate-favorite', { $setOnInsert : { _id: 'update-debate-favorite', roles : ['admin', 'owner', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById( 'view-user-debates')?
		CaoLiao.models.Permissions.upsert( 'view-user-debates', { $setOnInsert : { _id: 'view-user-debates', roles : ['admin', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById( 'join-tag')?
		CaoLiao.models.Permissions.upsert( 'join-tag', { $setOnInsert : { _id: 'join-tag', roles : ['admin', 'owner', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById( 'webrtc-join')?
		CaoLiao.models.Permissions.upsert( 'webrtc-join', { $setOnInsert : { _id: 'webrtc-join', roles : ['admin', 'owner', 'user'] } })



	CaoLiao.settings.addGroup('Rule');
	#CaoLiao.settings.add('User_Rule_Enabled', true, { type: 'boolean', group: 'Rule', i18nLabel: 'Enabled', 'public': true })
	