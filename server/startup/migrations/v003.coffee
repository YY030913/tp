CaoLiao.Migrations.add
	version: 3
	up: ->


		CaoLiao.models.Subscriptions.tryDropIndex 'uid_1'
		CaoLiao.models.Subscriptions.tryDropIndex 'rid_1_uid_1'


		console.log 'Fixing ChatSubscription uid'
		CaoLiao.models.Subscriptions.find({uid: {$exists: true}}, {nonreactive: true}).forEach (sub) ->
			update = {}
			user = CaoLiao.models.Users.findOneById(sub.uid, {fields: {username: 1}})
			if user?
				update.$set ?= {}
				update.$unset ?= {}
				update.$set['u._id'] = user._id
				update.$set['u.username'] = user.username
				update.$unset.uid = 1

			if Object.keys(update).length > 0
				CaoLiao.models.Subscriptions.update(sub._id, update)


		console.log 'Fixing ChatRoom uids'
		CaoLiao.models.Rooms.find({'uids.0': {$exists: true}}, {nonreactive: true}).forEach (room) ->
			update = {}
			users = CaoLiao.models.Users.find {_id: {$in: room.uids}, username: {$exists: true}}, {fields: {username: 1}}
			usernames = users.map (user) ->
				return user.username

			update.$set ?= {}
			update.$unset ?= {}
			update.$set.usernames = usernames
			update.$unset.uids = 1

			user = CaoLiao.models.Users.findOneById(room.uid, {fields: {username: 1}})
			if user?
				update.$set['u._id'] = user._id
				update.$set['u.username'] = user.username
				update.$unset.uid = 1

			if room.t is 'd' and usernames.length is 2
				for k, v of update.$set
					room[k] = v
				for k, v of update.$unset
					delete room[k]

				oldId = room._id
				room._id = usernames.sort().join(',')
				CaoLiao.models.Rooms.insert(room)
				CaoLiao.models.Rooms.removeById(oldId)
				CaoLiao.models.Subscriptions.update({rid: oldId}, {$set: {rid: room._id}}, {multi: true})
				CaoLiao.models.Messages.update({rid: oldId}, {$set: {rid: room._id}}, {multi: true})
			else
				CaoLiao.models.Rooms.update(room._id, update)


		console.log 'Fixing ChatMessage uid'
		CaoLiao.models.Messages.find({uid: {$exists: true}}, {nonreactive: true}).forEach (message) ->
			update = {}
			user = CaoLiao.models.Users.findOneById(message.uid, {fields: {username: 1}})
			if user?
				update.$set ?= {}
				update.$unset ?= {}
				update.$set['u._id'] = user._id
				update.$set['u.username'] = user.username
				update.$unset.uid = 1

			if Object.keys(update).length > 0
				CaoLiao.models.Messages.update(message._id, update)

		console.log 'End'
