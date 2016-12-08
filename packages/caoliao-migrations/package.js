Package.describe({
	name: 'caoliao:migrations',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('caoliao:lib');
	api.use('caoliao:version');
	api.use('ecmascript');
	api.use('underscore@1.0.4');
	api.use('check@1.1.0');
	api.use('mongo@1.1.3');
	api.use('momentjs:moment@2.13.1');

	api.addFiles('migrations.js', 'server');
});
