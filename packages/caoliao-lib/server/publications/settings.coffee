Meteor.publish 'settings', (ids = []) ->
	return CaoLiao.models.Settings.findNotHiddenPublic(ids)

Meteor.publish 'admin-settings', ->
	unless @userId
		return @ready()

	if CaoLiao.authz.hasPermission( @userId, 'view-privileged-setting')
		return CaoLiao.models.Settings.findNotHidden()
	else
		return @ready()

