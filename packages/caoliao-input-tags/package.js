Package.describe({
	name: 'caoliao:input-tags',
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
	api.use('ecmascript');
	api.use('jquery@1.11.4');


	api.addFiles('input-tags.js', 'client');
	api.addFiles('input-tags.css', 'client');


	// api.addAssets('styles/side-nav.less', 'client');
});
