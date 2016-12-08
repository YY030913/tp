CaoLiao.Migrations.add
	version: 19
	up: ->
		###
		# Migrate existing admin users to Role based admin functionality
		# 'admin' role applies to global scope
		###
		admins = Meteor.users.find({ admin: true }, { fields: { _id: 1, username:1 } }).fetch()
		CaoLiao.authz.addUsersToRoles( _.pluck(admins, '_id'), ['admin'])
		Meteor.users.update({}, { $unset :{admin:''}}, {multi:true})
		usernames = _.pluck( admins, 'username').join(', ')
		console.log "Migrate #{usernames} from admin field to 'admin' role".green

		# Add 'user' role to all users
		users = Meteor.users.find().fetch()
		CaoLiao.authz.addUsersToRoles( _.pluck(users, '_id'), ['user'])
		usernames = _.pluck( users, 'username').join(', ')
		console.log "Add #{usernames} to 'user' role".green

		# Add 'moderator' role to channel/group creators
		rooms = CaoLiao.models.Rooms.findByTypes(['c','p']).fetch()
		_.each rooms, (room) ->
			creator = room?.u?._id
			if creator
				if Meteor.users.findOne({_id: creator})
					CaoLiao.authz.addUsersToRoles( creator, ['moderator'], room._id)
				else
					CaoLiao.models.Subscriptions.removeByRoomId room._id
					CaoLiao.models.Messages.removeByRoomId room._id
					CaoLiao.models.Rooms.removeById room._id
