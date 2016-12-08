Package.describe({
	name: 'caoliao:api',
	version: '0.0.1',
	summary: 'Rest API',
	git: ''
});

Npm.depends({
  "multer": "1.2.0"
});

Package.onUse(function(api) {
	api.versionsFrom('1.4.0.1');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib',
		'nimble:restivus@0.8.10'
	]);

	api.addFiles('server/api.coffee', 'server');
	api.addFiles('server/routes.coffee', 'server');
});
