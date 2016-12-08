CaoLiao.AdminBox.addOption
	href: 'admin-oauth-apps'
	i18nLabel: 'OAuth Apps'
	permissionGranted: ->
		return CaoLiao.authz.hasAllPermission('manage-oauth-apps')
