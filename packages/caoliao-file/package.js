Package.describe({
	name: 'caoliao:file',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');

	api.use('caoliao:lib');
	api.use('caoliao:version');
	api.use('coffeescript@1.0.11');

	api.addFiles('file.server.coffee', 'server');

	api.export('CaoLiaoFile', 'server');
});

Npm.depends({
	'mkdirp': '0.3.5',
	'gridfs-stream': '0.5.3',
	'gm': '1.18.1'
});
