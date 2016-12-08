Package.describe({
	name: 'caoliao:ui-account',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Npm.depends({
	'i18n-iso-countries': '1.6.0',
	'countries-cities': '0.0.11',
	// 'node-location': '1.0.1',
	'iso-3166-1-alpha-2': '1.0.0'
});

Package.onUse(function(api) {
	api.versionsFrom('1.2.1');
	
	api.use([
		'ecmascript',
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib',
		'sha@1.0.4'
	]);

	api.addFiles('account/account.html', 'client');
	api.addFiles('account/accountFlex.html', 'client');
	api.addFiles('account/accountPreferences.html', 'client');
	api.addFiles('account/accountProfile.html', 'client');
	api.addFiles('account/avatar/avatar.html', 'client');
	api.addFiles('account/avatar/prompt.html', 'client');
	api.addFiles('account/avatar/avatarImg.html', 'client');
	api.addFiles('account/accountSetting.html', 'client');

	api.addFiles('account/account.coffee', 'client');
	api.addFiles('account/accountFlex.coffee', 'client');
	api.addFiles('account/accountPreferences.coffee', 'client');
	api.addFiles('account/accountProfile.coffee', 'client');
	api.addFiles('account/avatar/avatar.coffee', 'client');
	api.addFiles('account/avatar/prompt.coffee', 'client');
	api.addFiles('account/avatar/avatarImg.coffee', 'client');
	api.addFiles('account/accountSetting.coffee', 'client');


	// api.addAssets('styles/account.css', 'client');invalid
});
