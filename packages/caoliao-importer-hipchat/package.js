Package.describe({
	name: 'caoliao:importer-hipchat',
	version: '0.0.1',
	summary: 'Importer for HipChat',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib@0.0.1',
		'caoliao:importer@0.0.1'
	]);
	api.use(['mrt:moment-timezone@0.2.1'], 'server');
	api.use('caoliao:logger', 'server');
	api.addFiles('server.coffee', 'server');
	api.addFiles('main.coffee', ['client', 'server']);
});
