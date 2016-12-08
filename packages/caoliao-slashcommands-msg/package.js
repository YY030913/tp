Package.describe({
	name: 'caoliao:slashcommands-msg',
	version: '0.0.1',
	summary: 'Command handler for the /msg command',
	git: ''
});

Package.onUse(function(api) {

	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'check@1.1.0',
		'caoliao:lib'
	]);

	api.use('templating@1.1.5', 'client');

	api.addFiles('client.coffee', 'client');
	api.addFiles('server.coffee', 'server');
});
