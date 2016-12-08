CaoLiao._setEmail = function(userId, email) {
	email = s.trim(email);
	if (!userId) {
		throw new Meteor.Error('error-invalid-user', 'Invalid user', { function: '_setEmail' });
	}

	if (!email) {
		throw new Meteor.Error('error-invalid-email', 'Invalid email', { function: '_setEmail' });
	}

	CaoLiao.validateEmailDomain(email);

	const user = CaoLiao.models.Users.findOneById(userId);

	// User already has desired username, return
	if (user.emails && user.emails[0] && user.emails[0].address === email) {
		return user;
	}

	// Check email availability
	if (!CaoLiao.checkEmailAvailability(email)) {
		throw new Meteor.Error('error-field-unavailable', email + ' is already in use :(', { function: '_setEmail', field: email });
	}

	// Set new email
	CaoLiao.models.Users.setEmail(user._id, email);
	user.email = email;
	return user;
};

CaoLiao.setEmail = CaoLiao.RateLimiter.limitFunction(CaoLiao._setEmail, 1, 60000, {
	0: function() { return !Meteor.userId() || !CaoLiao.authz.hasPermission(Meteor.userId(), 'edit-other-user-info'); } // Administrators have permission to change others emails, so don't limit those
});
