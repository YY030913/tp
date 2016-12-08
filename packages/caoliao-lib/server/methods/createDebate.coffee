Meteor.methods
	createDebate: (temp) ->
		_id = temp._id
		name = temp.name
		content = temp.content
		members = temp.members || []
		save = temp.save

		if !name? && !content? && _id?
			return;

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createDebate' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'create-debate') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createDebate' }

		if temp.debateType?
			if CaoLiao.models.Settings.findOne('User_Rule_Enabled') is true && CaoLiao.rule.allowCreateDebate(Meteor.userId(), temp.debateType)
				throw new Meteor.Error 'error-rule-not-allowed', "Not allowed", { method: 'createDebate' }
		else
			if CaoLiao.models.Settings.findOne('User_Rule_Enabled') is true && CaoLiao.rule.allowCreateDebate(Meteor.userId())
				throw new Meteor.Error 'error-rule-not-allowed', "Not allowed", { method: 'createDebate' }

		if name?
			exist = CaoLiao.models.Debates.findOneByName(name, {_id: {$ne: _id}})
			if exist?
				throw new Meteor.Error 'error-duplicate-debate-name', "A debate with name '" + name + "' exists", {function: 'createDebate', debate_name: name}

		now = new Date()
		user = Meteor.user()
		members.push user.username if user.username not in members

		option = {
			name: 1
		}

		# avoid duplicate names
		
		debate = 
			ts: now
			usernames: members
			u: user
			tags: []

		if !save?
			save = false

		if save is true
			debate.save = save
		else
			if !CaoLiao.models.Debates.findOneByName(name, {_id: {$ne: _id}})?
				debate.save = save

		if temp.debateType?
			debate.debateType = temp.debateType

		if temp.imgs?
			debate.imgs = temp.imgs


		if name?
			debate.name = name
		if content?
			debate.htmlBody = content

		CaoLiao.callbacks.run 'beforeCreateDebate', debate

		record = {}
		try
			if _id?
				temp = CaoLiao.models.Debates.findOneBySlug _id
				if temp?
					debate._id = _id
					if name?
						if save is true
							view = CaoLiao.models.Debates.findOneByName name, {_id: {$ne: _id}}

							if !view?
								if !temp?.rid?
									# create new room
									

									if not Meteor.userId()
										throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createChannel' }

									try
										nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
									catch
										nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

									if name.length > CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') || name.length < CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength')
										throw new Meteor.Error 'error-invalid-name-length', TAPi18n.__ "Invalid name name length must in #{CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength')} , #{CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength')}", { function: 'createChannel', name: name, min_length: CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength'), max_length: CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') }

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
											throw new Meteor.Error 'error-duplicate-channel-name', "A channel with name '" + name + "' exists", { function: 'createChannel', channel_name: name }

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
										did: _id

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

									CaoLiao.callbacks.run 'afterCreateChannel', user, room




									###
									room = CaoLiao.models.Rooms.createWithTypeNameUserAndUsernames 'c', name, user, members,
										ts: now
										did: _id

									for username in members
										member = CaoLiao.models.Users.findOneByUsername username
										if not member?
											continue

										extra = {}

										if username is user.username
											extra.ls = now
											extra.open = true

										CaoLiao.models.Subscriptions.createWithRoomAndUser room, member, extra
									###

									# set creator as debate moderator.  permission limited to debate by scoping to rid
									debate.rid = room._id
								else
									if name.length > CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') || name.length < CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength')
										throw new Meteor.Error 'error-invalid-name-length', TAPi18n.__ "Invalid name name length must in #{CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength')} , #{CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength')}", {  function: 'createChannel', name: name, min_length: CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MinLength'), max_length: CaoLiao.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') }

									CaoLiao.models.Rooms.setNameById temp.rid, name
									CaoLiao.models.Subscriptions.updateNameByRoomId temp.rid, name
								CaoLiao.models.Debates.createDebate debate
								

								tag = CaoLiao.models.Tags.findOneByNameAndType debate.debateType, "o"
								CaoLiao.models.Debates.pushTag _id, {_id: tag._id, name: tag.name}

								newstag = CaoLiao.models.Tags.findOneByNameAndType "News", "o"
								CaoLiao.models.Debates.pushTag _id, {_id: newstag._id, name: newstag.name}
								record._id = _id
							else
								throw new Meteor.Error 'error-duplicate-debate-name', "A debate with name '" + name + "' exists"
						else
							CaoLiao.models.Debates.createDebate debate
							record._id = _id
					else
						throw new Meteor.Error 'error-empty-debate-name', "A debate with name is empty"
				else
					throw new Meteor.Error 'error-notexist-debate-slug', "A debate with slug '" + slug + "' empty"
			else
				if name?
					throw new Meteor.Error 'error-init-debate', "A debate init error with name"
				else
					if save is true
						throw new Meteor.Error 'error-init-debate', "A debate init error with save"
					else
						temp = CaoLiao.models.Debates.find {save: false, "u._id": user._id}
						if temp.count() > 0
							record = temp.fetch()[0]
						else
							record = CaoLiao.models.Debates.createDebate debate
		catch error
			throw new Meteor.Error error.error, error.message, { method: 'createDebate' }


		# name = s.slugify name
		CaoLiao.callbacks.run 'afterCreateDebate', debate

		return record._id