Package.describe({
	name: 'caoliao:slashcommands-shrug',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /shrug commands',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use([
		'caoliao:lib'
	]);

	api.use('ecmascript');

	api.addFiles('shrug.js', ['server', 'client']);
});
