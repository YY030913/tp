Meteor.startup ->
	unless CaoLiao.models.Permissions.findOneById('access-tag')?
		CaoLiao.models.Permissions.upsert( 'access-tag', { $setOnInsert : { _id: 'access-tag', roles : ['admin', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById('manage-tags')?
		CaoLiao.models.Permissions.upsert( 'manage-tags', { $setOnInsert : { _id: 'manage-tags', roles : ['admin'] } })

	unless CaoLiao.models.Permissions.findOneById('manage-own-tags')?
		CaoLiao.models.Permissions.upsert( 'manage-own-tags', { $setOnInsert : { _id: 'manage-own-tags', roles : ['admin', 'owner'] } })

	unless CaoLiao.models.Permissions.findOneById('create-o-tag')?
		CaoLiao.models.Permissions.upsert( 'create-o-tag', { $setOnInsert : { _id: 'create-o-tag', roles : ['admin', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById('create-h-tag')?
		CaoLiao.models.Permissions.upsert( 'create-h-tag', { $setOnInsert : { _id: 'create-h-tag', roles : ['admin'] } })

	unless CaoLiao.models.Permissions.findOneById('create-u-tag')?
		CaoLiao.models.Permissions.upsert( 'create-u-tag', { $setOnInsert : { _id: 'create-u-tag', roles : ['admin', 'user'] } })
	
	unless CaoLiao.models.Permissions.findOneById('view-o-tag')?
		CaoLiao.models.Permissions.upsert( 'view-o-tag', { $setOnInsert : { _id: 'view-o-tag', roles : ['admin', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById('view-h-tag')?
		CaoLiao.models.Permissions.upsert( 'view-h-tag', { $setOnInsert : { _id: 'view-h-tag', roles : ['admin'] } })

	unless CaoLiao.models.Permissions.findOneById('view-u-tag')?
		CaoLiao.models.Permissions.upsert( 'view-u-tag', { $setOnInsert : { _id: 'view-u-tag', roles : ['admin', 'user'] } })

	unless CaoLiao.models.Permissions.findOneById('view-joined-tag')?
		CaoLiao.models.Permissions.upsert( 'view-joined-tag', { $setOnInsert : { _id: 'view-joined-tag', roles : ['admin'] } })

	Meteor.defer ->

		if not CaoLiao.models.Tags.findOneByNameAndType('Pk', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Pk',
				showOnSelectType: ['user', 'admin']
				default: true
			pktag = CaoLiao.models.Tags.findOneByNameAndType 'Pk', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser pktag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('Society_Topic', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Society_Topic',
				showOnSelectType: ['user', 'admin']
				default: true
			societytag = CaoLiao.models.Tags.findOneByNameAndType 'Society_Topic', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser societytag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('Hot', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Hot',
				showOnSelectType: ['admin']
				default: true
			hottag = CaoLiao.models.Tags.findOneByNameAndType 'Hot', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser hottag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('News', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'News', 
				showOnSelectType: ['admin']
				default: true
			newstag = CaoLiao.models.Tags.findOneByNameAndType 'News', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser newstag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('Institution_Match', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Institution_Match', 
				showOnSelectType: ['institution', 'admin']
				default: true
			institutiontag = CaoLiao.models.Tags.findOneByNameAndType 'Institution_Match', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser institutiontag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('Company_Discuss', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Company_Discuss', 
				showOnSelectType: ['company', 'admin']
				default: true
			companytag = CaoLiao.models.Tags.findOneByNameAndType 'Company_Discuss', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser companytag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}

		if not CaoLiao.models.Tags.findOneByNameAndType('Organization_Activity', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Organization_Activity', 
				showOnSelectType: ['organization', 'admin']
				default: true
			organizationtag = CaoLiao.models.Tags.findOneByNameAndType 'Organization_Activity', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser organizationtag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}


		if not CaoLiao.models.Tags.findOneByNameAndType('Government_Interpretation', 'o')?
			CaoLiao.models.Tags.createWithIdTypeAndName 'o', 'Government_Interpretation', 
				showOnSelectType: ['government', 'admin']
				default: true
			governmenttag = CaoLiao.models.Tags.findOneByNameAndType 'Government_Interpretation', 'o'
			CaoLiao.models.DebateSubscriptions.createWithTagAndUser governmenttag, {_id: 'caoliao', username: 'caoliao'}, {editable: false}


	CaoLiao.tagTypes.setPublish 'o', (code)->
		return CaoLiao.models.Tags.findByTypeAndName 'o', code, 
			name: 1,
			t: 1,
			cl: 1,
			u: 1,
			label: 1,
			usernames: 1,
			v: 1,
			livechatData: 1,
			topic: 1,
			tags: 1,
			sms: 1,
			code: 1,
			open: 1
		if CaoLiao.authz.hasPermission(this.userId, 'view-o-tag')
			return CaoLiao.models.Tags.findByTypeAndName 'o', code, options
		return this.ready()