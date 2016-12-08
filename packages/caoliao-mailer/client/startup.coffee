CaoLiao.AdminBox.addOption
	href: 'mailer'
	i18nLabel: 'Mailer'
	permissionGranted: ->
		return CaoLiao.authz.hasAllPermission('access-mailer')
