Package.describe({
	name: 'caoliao:tutum',
	version: '0.0.1',
	summary: 'CaoLiao tutum integration'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('coffeescript@1.0.11');
	api.use('caoliao:lib');

	api.addFiles('startup.coffee', 'server');
});

Npm.depends({
	'redis': '2.2.5'
});
