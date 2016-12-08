CaoLiao.Migrations.add
	version: 4
	up: ->

		CaoLiao.models.Messages.tryDropIndex 'rid_1'
		CaoLiao.models.Subscriptions.tryDropIndex 'u._id_1'


		console.log 'Rename rn to name'
		CaoLiao.models.Subscriptions.update({rn: {$exists: true}}, {$rename: {rn: 'name'}}, {multi: true})


		console.log 'Adding names to rooms without name'
		CaoLiao.models.Rooms.find({name: ''}).forEach (item) ->
			name = Random.id().toLowerCase()
			CaoLiao.models.Rooms.setNameById item._id, name
			CaoLiao.models.Subscriptions.update {rid: item._id}, {$set: {name: name}}, {multi: true}


		console.log 'Making room names unique'
		CaoLiao.models.Rooms.find().forEach (room) ->
			CaoLiao.models.Rooms.find({name: room.name, _id: {$ne: room._id}}).forEach (item) ->
				name = room.name + '-' + Random.id(2).toLowerCase()
				CaoLiao.models.Rooms.setNameById item._id, name
				CaoLiao.models.Subscriptions.update {rid: item._id}, {$set: {name: name}}, {multi: true}


		console.log 'End'
