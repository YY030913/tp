Package.describe({
	name: 'caoliao:mentions-flextab',
	version: '0.0.1',
	summary: 'Mentions Flextab',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'less@2.5.0',
		'caoliao:lib'
	]);

	api.use('templating@1.1.5', 'client');

	api.addFiles([
		'client/lib/MentionedMessage.coffee',
		'client/views/stylesheets/mentionsFlexTab.less',
		'client/views/mentionsFlexTab.html',
		'client/views/mentionsFlexTab.coffee',
		'client/actionButton.coffee',
		'client/tabBar.coffee'
	], 'client');

	api.addFiles([
		'server/publications/mentionedMessages.coffee'
	], 'server');
});
