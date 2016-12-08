Package.describe({
	name: 'caoliao:message-pin',
	version: '0.0.1',
	summary: 'Pin Messages'
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
		'client/lib/PinnedMessage.coffee',
		'client/actionButton.coffee',
		'client/messageType.js',
		'client/pinMessage.coffee',
		'client/tabBar.coffee',
		'client/views/pinnedMessages.html',
		'client/views/pinnedMessages.coffee',
		'client/views/stylesheets/messagepin.less'
	], 'client');

	api.addFiles([
		'server/settings.coffee',
		'server/pinMessage.coffee',
		'server/publications/pinnedMessages.coffee',
		'server/startup/indexes.coffee'
	], 'server');
});
