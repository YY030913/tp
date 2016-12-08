Package.describe({
	name: 'caoliao:tooltip',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.versionsFrom('1.2.1');
	api.use('ecmascript');
	api.use('templating@1.1.5', 'client');
	api.use('caoliao:lib');
	api.use('caoliao:theme');
	api.use('caoliao:ui-master');

	api.addAssets('tooltip.less', 'server');
	api.addFiles('loadStylesheet.js', 'server');

	api.addFiles('caoliao-tooltip.html', 'client');
	api.addFiles('caoliao-tooltip.js', 'client');

	api.addFiles('init.js', 'client');
});
