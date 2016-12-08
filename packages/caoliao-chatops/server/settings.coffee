Meteor.startup ->
	CaoLiao.settings.addGroup 'Chatops'
	CaoLiao.settings.add 'Chatops_Enabled', false, { type: 'boolean', group: 'Chatops', public: true }
	CaoLiao.settings.add 'Chatops_Username', false, { type: 'string', group: 'Chatops', public: true }
