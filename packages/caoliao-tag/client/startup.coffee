Meteor.subscribe 'flag'
###
CaoLiao.AdminBox.addOption
	href: 'admin-flags'
	i18nLabel: 'Flag'
	permissionGranted: ->
		return CaoLiao.authz.hasAllPermission('access-flag')
###
