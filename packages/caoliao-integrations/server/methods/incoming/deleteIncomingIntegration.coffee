Meteor.methods
	deleteIncomingIntegration: (integrationId) ->
		integration = null

		if CaoLiao.authz.hasPermission @userId, 'manage-integrations'
			integration = CaoLiao.models.Integrations.findOne(integrationId)
		else if CaoLiao.authz.hasPermission @userId, 'manage-own-integrations'
			integration = CaoLiao.models.Integrations.findOne(integrationId, { fields : {"_createdBy._id": @userId} })
		else
			throw new Meteor.Error 'not_authorized'

		if not integration?
			throw new Meteor.Error 'error-invalid-integration', 'Invalid integration', { method: 'deleteIncomingIntegration' }

		CaoLiao.models.Integrations.remove _id: integrationId

		return true
