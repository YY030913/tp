Meteor.methods
	updateDebateTag: (_id, tag) ->

		tag.name = _.trim(tag.name)
		user = Meteor.user()

		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateTag' }

		if CaoLiao.authz.hasPermission(user._id, 'update-debate-tag') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateTag' }

		now = new Date()

		option = {
			name: 1
		}

		exist = {}
		# avoid tag name not exist
		if tag._id?
			exist = Tag.findOneById tag._id
		else
			exist = Tag.findOneByNameAndType tag.name, "u"
			
		if not exist?
			tagid = Meteor.call 'createTag', {name: tag.name, description: tag, t: now}
			updateTag = {_id: tagid, name: tag.name, userId: user._id, username: user.username}
		else 
			if exist.u._id == user._id
				updateTag = {_id: exist._id, name: tag.name, userId: user._id, username: user.username}
				update = Tag.createOrUpdate tag
				CaoLiao.models.DebateSubscriptions.updateNameByTagId tag._id, tag.name
			else
				throw new Meteor.Error 'error-not-allowed', "Not allowed for current username", { method: 'updateDebateTag' }

		debate = CaoLiao.models.Debates.findOne {_id: _id}
		
		if debate?
			if tag._id?
				CaoLiao.models.Debates.pullTag _id, {_id: tag._id}
			CaoLiao.models.Debates.pushTag _id, updateTag
		return true