Package.describe({
	name: 'caoliao:integrations',
	version: '0.0.1',
	summary: 'Integrations with services and WebHooks',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('coffeescript@1.0.11');
	api.use('underscore@1.0.4');
	api.use('ecmascript');
	api.use('babel-compiler');
	api.use('simple:highlight.js@1.2.0');
	api.use('caoliao:lib');
	api.use('caoliao:authorization');
	api.use('caoliao:api');
	api.use('caoliao:theme');
	api.use('caoliao:logger');

	api.use('kadira:flow-router@2.10.1', 'client');
	api.use('templating@1.1.5', 'client');

	api.addFiles('lib/caoliao.coffee', ['server', 'client']);
	api.addFiles('client/collection.coffee', ['client']);
	api.addFiles('client/startup.coffee', 'client');
	api.addFiles('client/route.coffee', 'client');

	// views
	api.addFiles('client/views/integrations.html', 'client');
	api.addFiles('client/views/integrations.coffee', 'client');
	api.addFiles('client/views/integrationsNew.html', 'client');
	api.addFiles('client/views/integrationsNew.coffee', 'client');
	api.addFiles('client/views/integrationsIncoming.html', 'client');
	api.addFiles('client/views/integrationsIncoming.coffee', 'client');
	api.addFiles('client/views/integrationsOutgoing.html', 'client');
	api.addFiles('client/views/integrationsOutgoing.coffee', 'client');

	// stylesheets
	api.addAssets('client/stylesheets/integrations.less', 'server');
	api.addFiles('client/stylesheets/load.coffee', 'server');

	api.addFiles('server/logger.js', 'server');

	api.addFiles('server/models/Integrations.coffee', 'server');

	// publications
	api.addFiles('server/publications/integrations.coffee', 'server');

	// methods
	api.addFiles('server/methods/incoming/addIncomingIntegration.coffee', 'server');
	api.addFiles('server/methods/incoming/updateIncomingIntegration.coffee', 'server');
	api.addFiles('server/methods/incoming/deleteIncomingIntegration.coffee', 'server');
	api.addFiles('server/methods/outgoing/addOutgoingIntegration.coffee', 'server');
	api.addFiles('server/methods/outgoing/updateOutgoingIntegration.coffee', 'server');
	api.addFiles('server/methods/outgoing/deleteOutgoingIntegration.coffee', 'server');

	// api
	api.addFiles('server/api/api.coffee', 'server');


	api.addFiles('server/triggers.coffee', 'server');

	api.addFiles('server/processWebhookMessage.js', 'server');
});
