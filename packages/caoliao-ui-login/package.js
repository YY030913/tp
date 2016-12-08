Package.describe({
	name: 'caoliao:ui-login',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

// Npm.depends({
// 	'crypto': '0.0.3',
// 	'net': '1.0.2',
// 	'sys': 'v0.0.1',
// 	'events': '1.1.1',
// 	'util': '0.10.3',

// 	'hiredis': '0.5.0',
// 	'ranaly':'0.1.1'
// })

Package.onUse(function(api) {
	api.versionsFrom('1.2.1');

	api.use('accounts-base', ['client', 'server']);
	api.use('accounts-oauth', ['client', 'server']);
	api.use('google', ['client', 'server']);

	api.use([
		'ecmascript',
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib'
	]);

	// api.use(['cosmos:browserify@0.9.3'], 'client');

	api.use('kadira:flow-router@2.10.1', 'client');

	api.addFiles('routes.js', 'client');
	// api.addFiles('app.browserify.js', 'client');

	api.addFiles('reset-password/resetPassword.html', 'client');
	api.addFiles('reset-password/resetPassword.js', 'client');

	api.addFiles('login/footer.html', 'client');
	api.addFiles('login/form.html', 'client');
	api.addFiles('login/header.html', 'client');
	api.addFiles('login/layout.html', 'client');
	api.addFiles('login/layout.js', 'client');
	api.addFiles('login/services.html', 'client');
	api.addFiles('login/social.html', 'client');

	api.addFiles('username/layout.html', 'client');
	api.addFiles('username/username.html', 'client');

	api.addFiles('login/footer.coffee', 'client');
	api.addFiles('login/form.coffee', 'client');
	api.addFiles('login/header.coffee', 'client');
	api.addFiles('login/services.coffee', 'client');
	api.addFiles('login/social.coffee', 'client');
	api.addFiles('username/username.coffee', 'client');

	// api.export('ranaly', 'client');
});
