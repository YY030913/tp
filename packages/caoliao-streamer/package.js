Package.describe({
	name: 'caoliao:streamer',
	version: '0.5.0',
	summary: 'DB less realtime communication for meteor',
	git: 'https://github.com/caoliao/meteor-streamer.git'
});

Package.on_use(function(api) {
	api.use('ddp-common@1.2.6');
	api.use('ecmascript@0.6.1');
	api.use('check@1.2.3');
	api.use('tracker@1.1.0');

	api.addFiles('lib/ev.js');

	api.addFiles('client/client.js', 'client');

	api.addFiles('server/server.js', 'server');

	api.export('Streamer');
});
