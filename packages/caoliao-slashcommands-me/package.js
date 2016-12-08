Package.describe({
	name: 'caoliao:slashcommands-me',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /me commands',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib'
	]);

	api.addFiles('me.coffee', ['server', 'client']);
});
