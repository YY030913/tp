Package.describe({
	name: 'caoliao:message-star',
	version: '0.0.1',
	summary: 'Star Messages',
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
		'client/lib/StarredMessage.coffee',
		'client/actionButton.coffee',
		'client/starMessage.coffee',
		'client/tabBar.coffee',
		'client/views/starredMessages.html',
		'client/views/starredMessages.coffee',
		'client/views/stylesheets/messagestar.less'
	], 'client');

	api.addFiles([
		'server/settings.coffee',
		'server/starMessage.coffee',
		'server/publications/starredMessages.coffee',
		'server/startup/indexes.coffee'
	], 'server');
});
