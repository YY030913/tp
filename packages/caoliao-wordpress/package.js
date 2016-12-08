Package.describe({
	name: 'caoliao:wordpress',
	version: '0.0.1',
	summary: 'CaoLiao settings for WordPress Oauth Flow'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('coffeescript@1.0.11');
	api.use('caoliao:lib');
	api.use('ecmascript');
	api.use('caoliao:custom-oauth');

	api.use('templating@1.1.5', 'client');

	api.addFiles('common.coffee');
	api.addFiles('wordpress-login-button.css', 'client');
	api.addFiles('startup.coffee', 'server');
});
