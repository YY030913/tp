Package.describe({
	name: 'caoliao:cas',
	summary: 'CAS support for accounts',
	version: '1.0.0',
	git: 'https://github.com/caoliao/caoliao-cas'
});

Package.onUse(function(api) {

	api.versionsFrom('1.4.0.1');

	// Server libs
	api.use('caoliao:lib', 'server');
	api.use('caoliao:logger', 'server');
	api.use('service-configuration@1.0.5', 'server');
	api.use('routepolicy@1.0.6', 'server');
	api.use('webapp@1.2.3', 'server');
	api.use('accounts-base@1.2.2', 'server');

	api.use('underscore@1.0.4');
	api.use('ecmascript');

	// Server files
	api.add_files('cas_caoliao.js', 'server');
	api.add_files('cas_server.js', 'server');

	// Client files
	api.add_files('cas_client.js', 'client');

});

Npm.depends({
	cas: '0.0.3'
});
