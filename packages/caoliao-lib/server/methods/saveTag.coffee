Meteor.methods
	'saveTag': (tagData) ->
		if not Meteor.userId() or not CaoLiao.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error "error-action-not-allowed", 'Accessing permissions is not allowed', { method: 'tags:saveTag', action: 'Accessing_permissions' }

		if not tagData.name?
			throw new Meteor.Error 'error-role-name-required', 'Tag name is required', { method: 'authorization:saveTag' }

		if tagData.scope not in ['Users', 'Subscriptions', 'Debates']
			tagData.scope = 'Users'

		if tagData.t.length > 1
			tagData.t = 'o'


		tagData.ts = new Date()
		tagData.u = {
			_id: Meteor.userId()
			username: Meteor.user().username
		}
		update = CaoLiao.models.Tags.createOrUpdate tagData

		if CaoLiao.settings.get('UI_DisplayRoles')
			CaoLiao.Notifications.notifyAll('tag-change', { type: 'changed', _id: tagData.name });

		return update
