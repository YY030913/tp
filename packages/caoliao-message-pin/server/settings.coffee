Meteor.startup ->
	CaoLiao.settings.add 'Message_AllowPinning', true, { type: 'boolean', group: 'Message', public: true }
	CaoLiao.models.Permissions.upsert('pin-message', { $setOnInsert: { roles: ['owner', 'moderator', 'admin'] } });
