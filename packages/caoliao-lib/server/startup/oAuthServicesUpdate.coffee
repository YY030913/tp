logger = new Logger 'caoliao:lib',
	methods:
		oauth_updated:
			type: 'info'

timer = undefined
OAuthServicesUpdate = ->
	Meteor.clearTimeout timer if timer?

	timer = Meteor.setTimeout ->
		services = CaoLiao.models.Settings.find({_id: /^(Accounts_OAuth_|Accounts_OAuth_Custom_)[a-z0-9_-]+$/i}).fetch()
		for service in services
			logger.oauth_updated service._id

			serviceName = service._id.replace('Accounts_OAuth_', '')
			if serviceName is 'Meteor'
				serviceName = 'meteor-developer'

			if /Accounts_OAuth_Custom_/.test service._id
				serviceName = service._id.replace('Accounts_OAuth_Custom_', '')

			if service.value is true
				data =
					clientId: CaoLiao.models.Settings.findOneById("#{service._id}_id")?.value
					secret: CaoLiao.models.Settings.findOneById("#{service._id}_secret")?.value


				if /Accounts_OAuth_Custom_/.test service._id
					data.custom = true
					data.serverURL = CaoLiao.models.Settings.findOneById("#{service._id}_url")?.value
					data.tokenPath = CaoLiao.models.Settings.findOneById("#{service._id}_token_path")?.value
					data.identityPath = CaoLiao.models.Settings.findOneById("#{service._id}_identity_path")?.value
					data.authorizePath = CaoLiao.models.Settings.findOneById("#{service._id}_authorize_path")?.value
					data.buttonLabelText = CaoLiao.models.Settings.findOneById("#{service._id}_button_label_text")?.value
					data.buttonLabelColor = CaoLiao.models.Settings.findOneById("#{service._id}_button_label_color")?.value
					data.loginStyle = CaoLiao.models.Settings.findOneById("#{service._id}_login_style")?.value
					data.buttonColor = CaoLiao.models.Settings.findOneById("#{service._id}_button_color")?.value
					data.tokenSentVia = CaoLiao.models.Settings.findOneById("#{service._id}_token_sent_via")?.value
					new CustomOAuth serviceName.toLowerCase(),
						serverURL: data.serverURL
						tokenPath: data.tokenPath
						identityPath: data.identityPath
						authorizePath: data.authorizePath
						loginStyle: data.loginStyle
						tokenSentVia: data.tokenSentVia

				if serviceName is 'Facebook'
					data.appId = data.clientId
					delete data.clientId

				if serviceName is 'Twitter'
					data.consumerKey = data.clientId
					delete data.clientId

				if serviceName is 'WeChat'
					data.appId = data.clientId
					delete data.clientId
					
				ServiceConfiguration.configurations.upsert {service: serviceName.toLowerCase()}, $set: data
			else
				ServiceConfiguration.configurations.remove {service: serviceName.toLowerCase()}
	, 2000


OAuthServicesRemove = (_id) ->
	serviceName = _id.replace('Accounts_OAuth_Custom_', '')
	ServiceConfiguration.configurations.remove {service: serviceName.toLowerCase()}


CaoLiao.models.Settings.find().observe
	added: (record) ->
		if /^Accounts_OAuth_.+/.test record._id
			OAuthServicesUpdate()

	changed: (record) ->
		if /^Accounts_OAuth_.+/.test record._id
			OAuthServicesUpdate()

	removed: (record) ->
		if /^Accounts_OAuth_Custom.+/.test record._id
			OAuthServicesRemove record._id
