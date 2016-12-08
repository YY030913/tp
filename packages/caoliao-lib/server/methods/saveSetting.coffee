Meteor.methods
	saveSetting: (_id, value) ->
		if Meteor.userId()?
			user = Meteor.users.findOne Meteor.userId()

		unless CaoLiao.authz.hasPermission(Meteor.userId(), 'edit-privileged-setting') is true
			throw new Meteor.Error 'error-action-not-allowed', 'Editing settings is not allowed', { method: 'saveSetting' }

		# console.log "saveSetting -> ".green, _id, value
		CaoLiao.settings.updateById _id, value
		return true
