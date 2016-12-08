Package.describe({
	name: 'caoliao:favico',
	version: '0.0.1',
	summary: 'Favico.js for CaoLiao'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.versionsFrom('1.0');
	api.use([
		'coffeescript@1.0.11'
	], 'client');
	api.addFiles([
		'favico.js'
	], 'client');
});
