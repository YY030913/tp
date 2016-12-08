Meteor.methods
	sendInvitationEmail: (emails) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'sendInvitationEmail' }

		unless CaoLiao.authz.hasRole(Meteor.userId(), 'admin')
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'sendInvitationEmail' }

		rfcMailPattern = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
		validEmails = _.compact _.map emails, (email) -> return email if rfcMailPattern.test email

		header = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Header') || "")
		footer = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Footer') || "")

		if CaoLiao.settings.get('Invitation_Customized')
			subject = CaoLiao.settings.get('Invitation_Subject')
			html = CaoLiao.settings.get('Invitation_HTML')
		else
			subject = TAPi18n.__('Invitation_Subject_Default', { lng: Meteor.user()?.language || CaoLiao.settings.get('language') || 'en' })
			html = TAPi18n.__('Invitation_HTML_Default', { lng: Meteor.user()?.language || CaoLiao.settings.get('language') || 'en' })

		subject = CaoLiao.placeholders.replace(subject);

		for email in validEmails
			@unblock()

			html = CaoLiao.placeholders.replace(html, { email: email });

			Email.send
				to: email
				from: CaoLiao.settings.get 'From_Email'
				subject: subject
				html: header + html + footer

		return validEmails
