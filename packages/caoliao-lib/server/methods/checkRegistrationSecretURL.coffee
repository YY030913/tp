Meteor.methods
	checkRegistrationSecretURL: (hash) ->
		return hash is CaoLiao.settings.get 'Accounts_RegistrationForm_SecretURL'
