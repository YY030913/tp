CaoLiao.Migrations.add
	version: 6
	up: ->

		console.log 'Changin _id of #general channel room from XXX to GENERAL'
		room = CaoLiao.models.Rooms.findOneByName('general')
		if room?._id is not 'GENERAL'
			CaoLiao.models.Subscriptions.update({'rid':room._id},{'$set':{'rid':'GENERAL'}},{'multi':1})
			CaoLiao.models.Messages.update({'rid':room._id},{'$set':{'rid':'GENERAL'}},{'multi':1})
			CaoLiao.models.Rooms.removeById(room._id)
			delete room._id
			CaoLiao.models.Rooms.upsert({'_id':'GENERAL'},{$set: room})


		console.log 'End'
