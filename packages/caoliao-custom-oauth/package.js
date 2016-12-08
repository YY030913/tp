Package.describe({
	name: 'caoliao:custom-oauth',
	summary: 'Custom OAuth flow',
	version: '1.0.0'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');

	api.use('check@1.1.0');
	api.use('oauth@1.1.6');
	api.use('oauth2@1.1.5');
	api.use('underscore@1.0.4');
	api.use('coffeescript@1.0.11');
	api.use('accounts-oauth@1.1.8');
	api.use('service-configuration@1.0.5');
	api.use('underscorestring:underscore.string@3.3.4');

	api.use('templating@1.1.5', 'client');

	api.use('http@1.1.1', 'server');


	api.addFiles('custom_oauth_client.coffee', 'client');

	api.addFiles('custom_oauth_server.coffee', 'server');

	api.export('CustomOAuth');
});
