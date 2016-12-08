Meteor.subscribe 'integrations'

CaoLiao.AdminBox.addOption
	href: 'admin-integrations'
	i18nLabel: 'Integrations'
	permissionGranted: ->
		return CaoLiao.authz.hasAtLeastOnePermission(['manage-integrations', 'manage-own-integrations'])
