Package.describe({
	name: 'caoliao:assets',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.4.0.1');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'webapp@1.2.3',
		'caoliao:file',
		'caoliao:lib',
		'webapp-hashing@1.0.5'
	]);

	api.addFiles('server/assets.coffee', 'server');
});

Npm.depends({
	'image-size': '0.4.0',
	'mime-types': '2.1.9'
});
