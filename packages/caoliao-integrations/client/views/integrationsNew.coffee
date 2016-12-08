Template.integrationsNew.helpers
	hasPermission: ->
		return CaoLiao.authz.hasAtLeastOnePermission(['manage-integrations', 'manage-own-integrations'])
