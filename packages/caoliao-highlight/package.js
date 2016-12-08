Package.describe({
	name: 'caoliao:highlight',
	version: '0.0.1',
	summary: 'Message pre-processor that will highlight code syntax',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'simple:highlight.js@1.2.0',
		'caoliao:lib'
	]);

	api.addFiles('highlight.coffee', ['server', 'client']);
});
