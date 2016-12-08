# Deny Account.createUser in client and set Meteor.loginTokenExpires
accountsConfig = { forbidClientAccountCreation: true, loginExpirationInDays: CaoLiao.settings.get 'Accounts_LoginExpiration' }
Accounts.config accountsConfig

CaoLiao.settings.get 'Accounts_AllowedDomainsList', (_id, value) ->
	domainWhiteList = _.map value.split(','), (domain) -> domain.trim()
	restrictCreationByEmailDomain = if domainWhiteList.length == 1 then domainWhiteList[0] else (email) ->
		ret = false
		for domain in domainWhiteList
			if email.match('@' + RegExp.escape(domain) + '$')
				ret = true
				break;

		return ret
	delete Accounts._options['restrictCreationByEmailDomain']

	if not _.isEmpty value
		Accounts.config({ restrictCreationByEmailDomain: restrictCreationByEmailDomain });

Accounts.emailTemplates.siteName = CaoLiao.settings.get 'Site_Name';
Accounts.emailTemplates.from = "#{CaoLiao.settings.get 'Site_Name'} <#{CaoLiao.settings.get 'From_Email'}>";

verifyEmailHtml = Accounts.emailTemplates.verifyEmail.text
Accounts.emailTemplates.verifyEmail.html = (user, url) ->
	url = url.replace Meteor.absoluteUrl(), Meteor.absoluteUrl() + 'login/'
	verifyEmailHtml user, url

resetPasswordHtml = Accounts.emailTemplates.resetPassword.text
Accounts.emailTemplates.resetPassword.html = (user, url) ->
	url = url.replace /\/#\//, '/'
	resetPasswordHtml user, url

Accounts.emailTemplates.enrollAccount.subject = (user) ->
	if CaoLiao.settings.get 'Accounts_Enrollment_Customized'
		subject = CaoLiao.settings.get 'Accounts_Enrollment_Email_Subject'
	else
		subject = TAPi18n.__('Accounts_Enrollment_Email_Subject_Default', { lng: user?.language || CaoLiao.settings.get('language') || 'en' })

	return CaoLiao.placeholders.replace(subject);

Accounts.emailTemplates.enrollAccount.html = (user, url) ->

	if CaoLiao.settings.get 'Accounts_Enrollment_Customized'
		html = CaoLiao.settings.get 'Accounts_Enrollment_Email'
	else
		html = TAPi18n.__('Accounts_Enrollment_Email_Default', { lng: user?.language || CaoLiao.settings.get('language') || 'en' })

	header = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Header') || "")
	footer = CaoLiao.placeholders.replace(CaoLiao.settings.get('Email_Footer') || "")
	html = CaoLiao.placeholders.replace(html, {
		name: user.name,
		email: user.emails?[0]?.address
	});

	return header + html + footer;

Accounts.onCreateUser (options, user) ->
	# console.log 'onCreateUser ->',JSON.stringify arguments, null, '  '
	# console.log 'options ->',JSON.stringify options, null, '  '
	# console.log 'user ->',JSON.stringify user, null, '  '

	CaoLiao.callbacks.run 'beforeCreateUser', options, user

	user.status = 'offline'
	user.active = not CaoLiao.settings.get 'Accounts_ManuallyApproveNewUsers'

	if not user?.name? or user.name is ''
		if options.profile?.name?
			user.name = options.profile?.name

	if user.services?
		for serviceName, service of user.services
			if not user?.name? or user.name is ''
				if service.name?
					user.name = service.name
				else if service.username?
					user.name = service.username

			if not user.emails? and service.email?
				user.emails = [
					address: service.email
					verified: true
				]

	return user

# Wrap insertUserDoc to allow executing code after Accounts.insertUserDoc is run
Accounts.insertUserDoc = _.wrap Accounts.insertUserDoc, (insertUserDoc, options, user) ->
	roles = []
	if Match.test(user.globalRoles, [String]) and user.globalRoles.length > 0
		roles = roles.concat user.globalRoles

	delete user.globalRoles

	user.type ?= 'user'

	_id = insertUserDoc.call(Accounts, options, user)

	if roles.length is 0
		# when inserting first user give them admin privileges otherwise make a regular user
		hasAdmin = CaoLiao.models.Users.findOne({ roles: 'admin' }, {fields: {_id: 1}})
		if hasAdmin?
			roles.push 'user'
		else
			roles.push 'admin'

	CaoLiao.authz.addUserRoles(_id, roles)

	CaoLiao.callbacks.run 'afterCreateUser', options, user
	return _id

Accounts.validateLoginAttempt (login) ->
	login = CaoLiao.callbacks.run 'beforeValidateLogin', login

	if login.allowed isnt true
		return login.allowed

	if !!login.user?.active isnt true
		throw new Meteor.Error 'error-user-is-not-activated', 'User is not activated', { function: 'Accounts.validateLoginAttempt' }
		return false

	# If user is admin, no need to check if email is verified
	if 'admin' not in login.user?.roles and login.type is 'password' and CaoLiao.settings.get('Accounts_EmailVerification') is true
		validEmail = login.user.emails.filter (email) ->
			return email.verified is true

		if validEmail.length is 0
			throw new Meteor.Error 'error-invalid-email', 'Invalid email __email__'
			return false

	CaoLiao.models.Users.updateLastLoginById login.user._id

	Meteor.defer ->
		CaoLiao.callbacks.run 'afterValidateLogin', login

	return true

Accounts.validateNewUser (user) ->
	if CaoLiao.settings.get('Accounts_Registration_AuthenticationServices_Enabled') is false and CaoLiao.settings.get('LDAP_Enable') is false and not user.services?.password?
		throw new Meteor.Error 'registration-disabled-authentication-services', 'User registration is disabled for authentication services'
	return true
