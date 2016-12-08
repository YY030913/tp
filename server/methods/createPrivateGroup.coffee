Meteor.methods
	createPrivateGroup: (name, members) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createPrivateGroup' }

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'create-p')
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createPrivateGroup' }

		###
		try
			nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test name
			throw new Meteor.Error 'error-invalid-name', "Invalid name", { method: 'createPrivateGroup' }
		###

		if name.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || name.length < CaoLiao.settings.get('UTF8_Names_MinLength')
			throw new Meteor.Error 'error-invalid-name', "Invalid name name length must in #{CaoLiao.settings.get('UTF8_Names_MinLength')} , #{CaoLiao.settings.get('UTF8_Names_MaxLength')}", { method: 'createChannel' }

		now = new Date()

		me = Meteor.user()

		members.push me.username

		# name = s.slugify name

		# avoid duplicate names
		if CaoLiao.models.Rooms.findOneByName name
			if CaoLiao.models.Rooms.findOneByName(name).archived
				throw new Meteor.Error 'error-archived-duplicate-name', "There's an archived channel with name " + name, { method: 'createPrivateGroup', room_name: name }
			else
				throw new Meteor.Error 'error-duplicate-channel-name', "A channel with name '" + name + "' exists", { method: 'createPrivateGroup', room_name: name }

		# create new room
		room = CaoLiao.models.Rooms.createWithTypeNameUserAndUsernames 'p', name, me, members,
			ts: now

		for username in members
			member = CaoLiao.models.Users.findOneByUsername(username, { fields: { username: 1 }})
			if not member?
				continue

			extra = {}

			if username is me.username
				extra.ls = now
			else
				extra.alert = true

			CaoLiao.models.Subscriptions.createWithRoomAndUser room, member, extra

		# set creator as group moderator.  permission limited to group by scoping to rid
		CaoLiao.authz.addUserRoles(Meteor.userId(), ['owner'], room._id)

		return {
			rid: room._id
		}
