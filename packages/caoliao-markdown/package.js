Package.describe({
	name: 'caoliao:markdown',
	version: '0.0.1',
	summary: 'Message pre-processor that will process selected markdown notations',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('coffeescript@1.0.11');
	api.use('underscore@1.0.4');
	api.use('templating@1.1.5');
	api.use('underscorestring:underscore.string@3.3.4');
	api.use('caoliao:lib');

	api.addFiles('settings.coffee', 'server');
	api.addFiles('markdown.coffee');
});

Package.onTest(function(api) {
	api.use('coffeescript@1.0.11');
	api.use('sanjo:jasmine@0.20.2');
	api.use('caoliao:lib');
	api.use('caoliao:markdown');

	api.addFiles('tests/jasmine/client/unit/markdown.spec.coffee', 'client');
});
