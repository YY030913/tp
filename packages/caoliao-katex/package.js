Package.describe({
	name: 'caoliao:katex',
	version: '0.0.1',
	summary: 'KaTeX plugin for TeX math rendering',
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
	api.addFiles('katex.coffee');
	api.addFiles('client/katex/katex.min.js', 'client');
	api.addFiles('client/katex/katex.min.css', 'client');
	api.addFiles('client/style.css', 'client');

	var _ = Npm.require('underscore');
	var fs = Npm.require('fs');	
	var fontFiles = _.map(fs.readdirSync('packages/caoliao-katex/client/katex/fonts'), function(filename) {
		return 'client/katex/fonts/' + filename;
	});
	


	api.addAssets(fontFiles, 'client');
});

Package.onTest(function(api) {
	api.use('coffeescript@1.0.11');
	api.use('sanjo:jasmine@0.20.2');
	api.use('caoliao:lib');
	api.use('caoliao:katex');

	api.addFiles('tests/jasmine/client/unit/katex.spec.coffee', 'client');
});
