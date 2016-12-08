Meteor.startup ->
	###
	defaultMedals = [
		{ name: 'welcome', cover:'', url:'images/ad.jpg', title:'welcome', description: 'Admin' }
	]

	for medal in defaultMedals
		CaoLiao.models.Ad.upsert { _id: medal.name }, { $setOnInsert: {description: medal.description || '', protected: true } }
	###

	unless CaoLiao.models.Permissions.findOneById('manage-ads')?
		CaoLiao.models.Permissions.upsert( 'manage-ads', { $setOnInsert : { _id: 'manage-ads', roles : ['admin'] } })

	unless CaoLiao.models.Permissions.findOneById('create-ad')?
		CaoLiao.models.Permissions.upsert( 'create-ad', { $setOnInsert : { _id: 'create-ad', roles : ['admin'] } })