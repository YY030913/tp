Meteor.methods
	canAccessTag: (tid, userId) ->
		user = CaoLiao.models.Users.findOneById userId, fields: username: 1

		unless user?.username
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'canAccessTag' }

		unless tid
			throw new Meteor.Error 'error-invalid-tag', 'Invalid tag', { method: 'canAccessTag' }

		tag = CaoLiao.models.Tags.findOneById tid, { fields: { usernames: 1, t: 1, name: 1} }

		if tag
			if CaoLiao.authz.canAccessTag.call(this, tag, user)
				return _.pick tag, ['_id', 't', 'name', 'usernames']
			else
				return false
		else
			throw new Meteor.Error 'error-invalid-tag', 'Invalid tag', { method: 'canAccessTag' }
