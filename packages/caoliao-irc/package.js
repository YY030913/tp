Package.describe({
	name: 'caoliao:irc',
	version: '0.0.1',
	summary: 'CaoLiao libraries',
	git: ''
});

Npm.depends({
	'coffee-script': '1.9.3',
	'lru-cache': '2.6.5'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib'
	]);

	api.addFiles('irc.server.coffee', 'server');
	api.export(['Irc'], ['server']);
});
