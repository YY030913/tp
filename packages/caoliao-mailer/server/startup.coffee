Meteor.startup ->
	CaoLiao.models.Permissions.upsert( 'access-mailer', { $setOnInsert : { _id: 'access-mailer', roles : ['admin'] } })
