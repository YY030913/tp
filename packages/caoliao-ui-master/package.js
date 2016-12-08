Package.describe({
	name: 'caoliao:ui-master',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.versionsFrom('1.2.1');

	api.use([
		'jquery',
		'mongo@1.1.3',
		'ecmascript',
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'yasinuslu:blaze-meta',
		'caoliao:lib',
		'caoliao:ui',
		'meteorhacks:inject-initial@1.0.4',
		'meteorhacks:fast-render@2.13.0'
	]);

	api.addFiles('master/main.html', 'client');
	api.addFiles('master/loading.html', 'client');
	api.addFiles('master/pageLoading.html', 'client');
	api.addFiles('master/error.html', 'client');
	api.addFiles('master/logoLayout.html', 'client');

	api.addFiles('master/main.coffee', 'client');
	api.addFiles('master/pageLoading.coffee', 'client');
	

	api.addFiles('server/inject.js', 'server');
	api.addFiles('server/fastRender.js', 'server');

	// api.addFiles('stylesheets/bootstrap.min.css', ['client']);
	// api.addFiles('stylesheets/bootstrap.min.js', ['client']);
});
