Package.describe({
	name: 'caoliao:webrtc',
	version: '0.0.1',
	summary: 'Package WebRTC for Meteor server',
	git: ''
});

Cordova.depends({
  'cordova-plugin-media-capture': '1.3.0'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('caoliao:lib');
	api.use('coffeescript@1.0.11');
	// api.use('meteorflux:dispatcher');
	// api.use('meteorflux:reactive-dependency');
	// api.use('tracker');
	// api.use('lepozepo:streams');
	api.use('templating@1.1.5', 'client');

	api.addFiles('adapter.js', 'client');
	api.addFiles('WebRTCClass.coffee', 'client');
	api.addFiles('screenShare.coffee', 'client');

	// api.addFiles('lib/stream.js', ['client', 'server']);
	// api.addFiles('lib/RTCActions.js', ['client']);


	api.addFiles('server/settings.coffee', 'server');
	// api.addFiles('server/webrtcStream.js', 'server');

	api.export('WebRTC');
});
