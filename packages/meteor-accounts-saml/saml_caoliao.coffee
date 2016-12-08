logger = new Logger 'steffo:meteor-accounts-saml',
	methods:
		updated:
			type: 'info'

CaoLiao.settings.addGroup 'SAML'
Meteor.methods
	addSamlService: (name) ->
		CaoLiao.settings.add "SAML_Custom_#{name}"                   , false                                                         , { type: 'boolean', group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Enable'}
		CaoLiao.settings.add "SAML_Custom_#{name}_provider"          , 'openidp'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Provider'}
		CaoLiao.settings.add "SAML_Custom_#{name}_entry_point"       , 'https://openidp.feide.no/simplesaml/saml2/idp/SSOService.php', { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Entry_point'}
		CaoLiao.settings.add "SAML_Custom_#{name}_issuer"            , 'https://caoliao/'                                        , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Issuer'}
		CaoLiao.settings.add "SAML_Custom_#{name}_cert"              , ''                                                            , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Cert'}
		CaoLiao.settings.add "SAML_Custom_#{name}_button_label_text" , ''                                                            , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Label_Text'}
		CaoLiao.settings.add "SAML_Custom_#{name}_button_label_color", '#FFFFFF'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Label_Color'}
		CaoLiao.settings.add "SAML_Custom_#{name}_button_color"      , '#13679A'                                                     , { type: 'string' , group: 'SAML', section: name, i18nLabel: 'Accounts_OAuth_Custom_Button_Color'}
		CaoLiao.settings.add "SAML_Custom_#{name}_generate_username" , false                                                         , { type: 'boolean', group: 'SAML', section: name, i18nLabel: 'SAML_Custom_Generate_Username'}

timer = undefined
updateServices = ->
	Meteor.clearTimeout timer if timer?

	timer = Meteor.setTimeout ->
		services = CaoLiao.models.Settings.find({_id: /^(SAML_Custom_)[a-z]+$/i}).fetch()

		Accounts.saml.settings.providers = []

		for service in services
			logger.updated service._id

			serviceName = 'saml'

			if service.value is true
				data =
					buttonLabelText: CaoLiao.models.Settings.findOneById("#{service._id}_button_label_text")?.value
					buttonLabelColor: CaoLiao.models.Settings.findOneById("#{service._id}_button_label_color")?.value
					buttonColor: CaoLiao.models.Settings.findOneById("#{service._id}_button_color")?.value
					clientConfig:
						provider: CaoLiao.models.Settings.findOneById("#{service._id}_provider")?.value

				Accounts.saml.settings.generateUsername = CaoLiao.models.Settings.findOneById("#{service._id}_generate_username")?.value

				Accounts.saml.settings.providers.push
					provider: data.clientConfig.provider
					entryPoint: CaoLiao.models.Settings.findOneById("#{service._id}_entry_point")?.value
					issuer: CaoLiao.models.Settings.findOneById("#{service._id}_issuer")?.value
					cert: CaoLiao.models.Settings.findOneById("#{service._id}_cert")?.value

				ServiceConfiguration.configurations.upsert {service: serviceName.toLowerCase()}, $set: data
			else
				ServiceConfiguration.configurations.remove {service: serviceName.toLowerCase()}
	, 2000

CaoLiao.models.Settings.find().observe
	added: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

	changed: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

	removed: (record) ->
		if /^SAML_.+/.test record._id
			updateServices()

Meteor.startup ->
	if not CaoLiao.models.Settings.findOne({_id: /^(SAML_Custom)[a-z]+$/i})?
		Meteor.call 'addSamlService', 'Default'
