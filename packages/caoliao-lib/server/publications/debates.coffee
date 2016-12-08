###
Meteor.publish 'debates', ->
	unless this.userId
		return this.ready()

	if CaoLiao.authz.hasPermission( @userId, 'view-debate')
		record = CaoLiao.models.Debates.findList {},
			{
				fields:
					name: 1
					u: 1
					ts: 1
					htmlBody: 1
			}
		return record
	else
		return @ready()
###