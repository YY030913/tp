Package.describe({
	name: 'caoliao:spotify',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate spotify on messages',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'templating@1.1.5',
		'underscore@1.0.4',
		'caoliao:oembed@0.0.1',
		'caoliao:lib'
	]);

	api.addFiles('lib/client/widget.coffee', 'client');
	api.addFiles('lib/client/oembedSpotifyWidget.html', 'client');

	api.addFiles('lib/spotify.coffee', ['server', 'client']);
});
