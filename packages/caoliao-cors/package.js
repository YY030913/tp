Package.describe({
	name: 'caoliao:cors',
	version: '0.0.1',
	summary: 'Enable CORS',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');

	api.use([
		'coffeescript@1.0.11',
		'webapp@1.2.3'
	]);

	api.addFiles('cors.coffee', 'server');
	api.addFiles('common.coffee');
});
