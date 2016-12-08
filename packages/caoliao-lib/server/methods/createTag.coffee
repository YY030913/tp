Meteor.methods
	createTag: (tagData) ->
		
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createTag' }

		if CaoLiao.authz.hasPermission(Meteor.userId(), 'create-o-tag') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createTag' }

		now = new Date()
		user = Meteor.user()

		members = []
		members.push {_id: user._id, username: user.username}

		option = {
			name: 1
		}

		tag = 
			ts: now
			u:
				_id: user._id
				username: user.username

		if tagData.name?
			tag.name = tagData.name
		if tagData.desc?
			tag.description = tagData.description
		if tagData.t?
			tag.t = tagData.t

		if tagData.showOnSelectType?
			_.each(tagData.showOnSelectType, (element, index, list)->
				if !CaoLiao.models.Roles.findOne(element)?
					throw new Meteor.Error 'error-not-find-the-role', "Not allowed", { method: 'createTag' }
			)
			tag.showOnSelectType = tagData.showOnSelectType


		CaoLiao.callbacks.run 'beforeCreateTag', tag

		update = CaoLiao.models.Tags.createOrUpdate tag

		tag._id = update.insertedId or update

		for u in members
			member = CaoLiao.models.Users.findOneById u._id

			if not member?
				continue
				
			extra = {}

			if u.username is user.username
				extra.ls = now
				extra.open = true
				extra.members = members

			CaoLiao.models.DebateSubscriptions.createWithFlagAndUser tag, user, extra
		
		CaoLiao.callbacks.run 'afterCreateTag', tag
		return tag._id