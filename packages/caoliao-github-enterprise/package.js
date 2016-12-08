Package.describe({
	name: 'caoliao:github-enterprise',
	version: '0.0.1',
	summary: 'CaoLiao settings for GitHub Enterprise Oauth Flow'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');

	api.use('coffeescript@1.0.11');
	api.use('caoliao:lib');
	api.use('caoliao:custom-oauth');

	api.use('templating@1.1.5', 'client');

	api.addFiles('common.coffee');
	api.addFiles('github-enterprise-login-button.css', 'client');
	api.addFiles('startup.coffee', 'server');
});
