Meteor.subscribe 'roles'

CaoLiao.authz.subscription = Meteor.subscribe 'permissions'

CaoLiao.AdminBox.addOption
	href: 'admin-permissions'
	i18nLabel: 'Permissions'
	permissionGranted: ->
		return CaoLiao.authz.hasAllPermission('access-permissions')
