Package.describe({
	name: 'caoliao:version',
	summary: '',
	version: '1.0.0'
});

Package.registerBuildPlugin({
	name: 'compileVersion',
	use: ['coffeescript'],
	sources: ['plugin/compile-version.coffee']
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('isobuild:compiler-plugin@1.0.0');
});
