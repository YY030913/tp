Package.describe({
	name: 'caoliao:iframe-login',
	summary: '',
	version: '1.0.0'
});

Package.onUse(function(api) {

	api.versionsFrom('1.0');

	// Server libs
	api.use('caoliao:logger', 'server');

	api.use('kadira:flow-router@2.10.1', 'client');

	api.use('caoliao:lib');
	api.use('accounts-base@1.2.2');
	api.use('underscore@1.0.4');
	api.use('ecmascript');
	api.use('reactive-var@1.0.6');
	api.use('http@1.1.1');
	api.use('tracker@1.0.9');

	api.imply('facebook@1.2.2');
	api.imply('twitter@1.1.5');
	api.imply('google@1.1.7');
	api.imply('oauth@1.1.6');

	// Server files
	api.addFiles('iframe_caoliao.js', 'server');
	api.addFiles('iframe_server.js', 'server');

	// Client files
	api.addFiles('iframe_client.js', 'client');
});
