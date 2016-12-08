Package.describe({
	name: 'caoliao:mailer',
	version: '0.0.1',
	summary: 'Mailer for CaoLiao'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'ddp-rate-limiter@1.0.0',
		'kadira:flow-router@2.10.1',
		'caoliao:lib',
		'caoliao:authorization@0.0.1'
	]);

	api.use('templating@1.1.5', 'client');

	api.addFiles('lib/Mailer.coffee');

	api.addFiles([
		'client/startup.coffee',
		'client/router.coffee',
		'client/views/mailer.html',
		'client/views/mailer.coffee',
		'client/views/mailerUnsubscribe.html',
		'client/views/mailerUnsubscribe.coffee'
	], 'client');

	api.addFiles([
		'server/startup.coffee',
		'server/models/Users.coffee',
		'server/functions/sendMail.coffee',
		'server/functions/unsubscribe.coffee',
		'server/methods/sendMail.coffee',
		'server/methods/unsubscribe.coffee'
	], 'server');

	api.export('Mailer');
});
