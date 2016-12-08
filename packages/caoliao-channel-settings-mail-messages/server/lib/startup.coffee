Meteor.startup ->
	permission = { _id: 'mail-messages', roles : [ 'admin' ] }
	CaoLiao.models.Permissions.upsert( permission._id, { $setOnInsert : permission })
