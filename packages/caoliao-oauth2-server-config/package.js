Package.describe({
	name: 'caoliao:oauth2-server-config',
	summary: 'Configure the OAuth2 Server',
	version: '1.0.0'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('webapp@1.2.3');
	api.use('coffeescript@1.0.11');
	api.use('caoliao:lib');
	api.use('caoliao:api');
	api.use('caoliao:theme');
	api.use('caoliao:oauth2-server');

	api.use('templating@1.1.5', 'client');
	api.use('kadira:flow-router@2.10.1', 'client');

	//// General //
	// Server
	api.addFiles('server/models/OAuthApps.coffee', 'server');

	//// OAuth //
	// Server
	api.addFiles('oauth/server/oauth2-server.coffee', 'server');
	api.addFiles('oauth/server/default-services.coffee', 'server');

	api.addAssets('oauth/client/stylesheets/oauth2.less', 'server');
	api.addFiles('oauth/client/stylesheets/load.coffee', 'server');

	// Client
	api.addFiles('oauth/client/oauth2-client.html', 'client');
	api.addFiles('oauth/client/oauth2-client.coffee', 'client');


	//// Admin //
	// Client
	api.addFiles('admin/client/startup.coffee', 'client');
	api.addFiles('admin/client/collection.coffee', 'client');
	api.addFiles('admin/client/route.coffee', 'client');
	api.addFiles('admin/client/views/oauthApp.html', 'client');
	api.addFiles('admin/client/views/oauthApp.coffee', 'client');
	api.addFiles('admin/client/views/oauthApps.html', 'client');
	api.addFiles('admin/client/views/oauthApps.coffee', 'client');

	// Server
	api.addFiles('admin/server/publications/oauthApps.coffee', 'server');
	api.addFiles('admin/server/methods/addOAuthApp.coffee', 'server');
	api.addFiles('admin/server/methods/updateOAuthApp.coffee', 'server');
	api.addFiles('admin/server/methods/deleteOAuthApp.coffee', 'server');
});
