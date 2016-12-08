Meteor.methods
	removeOAuthService: (name) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'removeOAuthService' })

		unless CaoLiao.authz.hasPermission( Meteor.userId(), 'add-oauth-service') is true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeOAuthService' }

		name = name.toLowerCase().replace(/[^a-z0-9]/g, '')
		name = s.capitalize(name)
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_url"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_token_path"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_identity_path"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_authorize_path"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_token_sent_via"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_id"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_secret"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_button_label_text"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_button_label_color"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_button_color"
		CaoLiao.settings.removeById "Accounts_OAuth_Custom_#{name}_login_style"
