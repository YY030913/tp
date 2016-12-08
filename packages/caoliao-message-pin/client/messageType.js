Meteor.startup(function() {
	CaoLiao.MessageTypes.registerType({
		id: 'message_pinned',
		system: true,
		message: 'Pinned_a_message'
	});
});
