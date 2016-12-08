Meteor.methods
	createChannel: (name, members) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createChannel' }

		try
			nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test name
			throw new Meteor.Error 'error-invalid-name', "Invalid name", { method: 'createChannel' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'create-c') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createChannel' }

		now = new Date()
		user = Meteor.user()

		members.push user.username if user.username not in members

		# avoid duplicate names
		if CaoLiao.models.Rooms.findOneByName name
			if CaoLiao.models.Rooms.findOneByName(name).archived
				throw new Meteor.Error 'error-archived-duplicate-name', "There's an archived channel with name " + name, { method: 'createChannel', room_name: name }
			else
				throw new Meteor.Error 'error-duplicate-channel-name', "A channel with name '" + name + "' exists", { method: 'createChannel', room_name: name }

		# name = s.slugify name

		CaoLiao.callbacks.run 'beforeCreateChannel', user,
			t: 'c'
			name: name
			ts: now
			usernames: members
			u:
				_id: user._id
				username: user.username

		# create new room
		room = CaoLiao.models.Rooms.createWithTypeNameUserAndUsernames 'c', name, user, members,
			ts: now

		for username in members
			member = CaoLiao.models.Users.findOneByUsername username
			if not member?
				continue

			extra = {}

			if username is user.username
				extra.ls = now
				extra.open = true

			CaoLiao.models.Subscriptions.createWithRoomAndUser room, member, extra

		# set creator as channel moderator.  permission limited to channel by scoping to rid
		CaoLiao.authz.addUserRoles(Meteor.userId(), ['owner'], room._id)

		Meteor.defer ->
			CaoLiao.callbacks.run 'afterCreateChannel', user, room

		return {
			rid: room._id
		}
