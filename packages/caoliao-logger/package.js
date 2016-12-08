Package.describe({
	name: 'caoliao:logger',
	version: '0.0.1',
	summary: 'Logger for CaoLiao'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');
	api.use('coffeescript@1.0.11');
	api.use('underscore@1.0.4');
	api.use('random@1.0.5');
	api.use('logging@1.0.8');
	api.use('nooitaf:colors@0.0.3');
	api.use('raix:eventemitter@0.1.3');
	api.use('templating@1.1.5', 'client');
	api.use('kadira:flow-router@2.10.1', 'client');

	api.addFiles('ansispan.js', 'client');
	api.addFiles('logger.coffee', 'client');
	api.addFiles('client/viewLogs.coffee', 'client');
	api.addFiles('client/views/viewLogs.html', 'client');
	api.addFiles('client/views/viewLogs.coffee', 'client');

	api.addFiles('server.coffee', 'server');

	api.export('Logger');
});
