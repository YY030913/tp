Package.describe({
	name: 'caoliao:statistics',
	version: '0.0.1',
	summary: 'Statistics generator',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib'
	]);

	// Statistics
	api.addFiles('lib/caoliao.coffee', [ 'client', 'server' ]);
	api.addFiles([
		'server/models/Statistics.coffee',
		'server/models/MRStatistics.coffee',
		'server/functions/get.coffee',
		'server/functions/save.coffee',
		'server/methods/getStatistics.coffee'
	], 'server');
});
