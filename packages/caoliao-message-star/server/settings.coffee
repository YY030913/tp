Meteor.startup ->
	CaoLiao.settings.add 'Message_AllowStarring', true, { type: 'boolean', group: 'Message', public: true }
