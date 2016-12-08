Package.describe({
	name: 'caoliao:slashcommands-invite',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /me commands',
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
