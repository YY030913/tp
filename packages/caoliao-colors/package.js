Package.describe({
	name: 'caoliao:colors',
	version: '0.0.1',
	summary: 'Message pre-processor that will process colors',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib'
	]);

	api.addFiles('client.coffee', 'client');
	api.addFiles('style.css', 'client');
});
