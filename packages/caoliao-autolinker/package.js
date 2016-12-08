Package.describe({
	name: 'caoliao:autolinker',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate links on messages',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.4.0.1');
	api.use('ecmascript');

	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib'
	]);

	api.addFiles([
		'autolinker.coffee',
		'lib/Autolinker.min.js'
	], ['client']);

	api.addFiles('settings.coffee', ['server']);
});
