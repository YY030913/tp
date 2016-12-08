Meteor.methods
	insertOrUpdateUser: (userData) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'insertOrUpdateUser' })

		user = Meteor.user()

		canEditUser = CaoLiao.authz.hasPermission( user._id, 'edit-other-user-info')
		canAddUser = CaoLiao.authz.hasPermission( user._id, 'create-user')

		if userData._id and user._id isnt userData._id and canEditUser isnt true
			throw new Meteor.Error 'error-action-not-allowed', 'Editing user is not allowed', { method: 'insertOrUpdateUser', action: 'Editing_user' }

		if not userData._id and canAddUser isnt true
			throw new Meteor.Error 'error-action-not-allowed', 'Adding user is not allowd', { method: 'insertOrUpdateUser', action: 'Adding_user' }

		unless s.trim(userData.name)
			throw new Meteor.Error 'error-the-field-is-required', 'The field Name is required', { method: 'insertOrUpdateUser', field: 'Name' }

		unless s.trim(userData.username)
			throw new Meteor.Error 'error-the-field-is-required', 'The field Username is required', { method: 'insertOrUpdateUser', field: 'Username' }

		###
		try
			nameValidation = new RegExp '^' + CaoLiao.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test userData.username
			throw new Meteor.Error 'error-input-is-not-a-valid-field', "#{userData.username} is not a valid username", { method: 'insertOrUpdateUser', input: userData.username, field: 'Username' }
		###

		if userData.username.length > CaoLiao.settings.get('UTF8_Names_MaxLength') || userData.username.length < CaoLiao.settings.get('UTF8_Names_MinLength')
			throw new Meteor.Error 'error-input-is-not-valid-length', "#{userData.username} is not a valid username", { method: 'insertOrUpdateUser', input: userData.username, min: CaoLiao.settings.get('UTF8_Names_MinLength'),  max: CaoLiao.settings.get('UTF8_Names_MaxLength')}

		if not userData._id and not userData.password
			throw new Meteor.Error 'error-the-field-is-required', 'The field Password is required', { method: 'insertOrUpdateUser', field: 'Password' }

		if not userData._id
			if not CaoLiao.checkUsernameAvailability userData.username
				throw new Meteor.Error 'error-field-unavailable', "#{userData.username} is already in use :(", { method: 'insertOrUpdateUser', field: userData.username }

			if userData.email and not CaoLiao.checkEmailAvailability userData.email
				throw new Meteor.Error 'error-field-unavailable', "#{userData.email} is already in use :(", { method: 'insertOrUpdateUser', field: userData.email }

			CaoLiao.validateEmailDomain(userData.email);

			# insert user
			createUser = { username: userData.username, password: userData.password }
			if userData.email
				createUser.email = userData.email

			_id = Accounts.createUser(createUser)

			updateUser =
				$set:
					name: userData.name
					roles: [ userData.role ]

			if userData.requirePasswordChange
				updateUser.$set.requirePasswordChange = userData.requirePasswordChange

			if userData.verified
				updateUser.$set['emails.0.verified'] = true

			Meteor.users.update { _id: _id }, updateUser

			if userData.joinDefaultChannels
				Meteor.runAsUser _id, ->
					Meteor.call('joinDefaultChannels');

			if userData.sendWelcomeEmail

				header = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Header') || "")
				footer = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Footer') || "")


				if CaoLiao.settings.get('Accounts_UserAddedEmail_Customized')
					subject = CaoLiao.settings.get('Accounts_UserAddedEmailSubject')
					html = CaoLiao.settings.get('Accounts_UserAddedEmail')
				else
					subject = TAPi18n.__('Accounts_UserAddedEmailSubject_Default', { lng: Meteor.user()?.language || CaoLiao.settings.get('language') || 'en' })
					html = TAPi18n.__('Accounts_UserAddedEmail_Default', { lng: Meteor.user()?.language || CaoLiao.settings.get('language') || 'en' })

				subject = CaoLiao.placeholders.replace(subject);
				html = CaoLiao.placeholders.replace(html, {
					name: userData.name,
					email: userData.email,
					password: userData.password
				});

				email = {
					to: userData.email
					from: CaoLiao.settings.get('From_Email'),
					subject: subject,
					html: header + html + footer
				};

				Email.send(email);

			return _id
		else
			#update user
			updateUser = {
				$set: {
					name: userData.name,
					requirePasswordChange: userData.requirePasswordChange
				}
			}
			if userData.verified
				updateUser.$set['emails.0.verified'] = true
			else
				updateUser.$set['emails.0.verified'] = false

			Meteor.users.update { _id: userData._id }, updateUser
			CaoLiao.setUsername userData._id, userData.username
			CaoLiao.setEmail userData._id, userData.email

			canEditUserPassword = CaoLiao.authz.hasPermission( user._id, 'edit-other-user-password')
			if canEditUserPassword and userData.password.trim()
				Accounts.setPassword userData._id, userData.password.trim()

			return true
