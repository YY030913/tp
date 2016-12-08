Package.describe({
	name: 'caoliao:version',
	summary: '',
	version: '1.0.0'
});

Package.registerBuildPlugin({
	name: 'compileVersion',
	use: ['coffeescript@1.0.11'],
	sources: ['plugin/compile-version.coffee']
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('isobuild:compiler-plugin@1.0.0');
});
