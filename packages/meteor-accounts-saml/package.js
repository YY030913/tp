Package.describe({
	'name': 'steffo:meteor-accounts-saml',
	'summary': 'SAML Login (SP) for Meteor. Works with OpenAM, OpenIDP and provides Single Logout.',
	'version': '0.0.1',
	'git': 'https://github.com/steffow/meteor-accounts-saml.git'
});

Package.on_use(function(api) {
	api.versionsFrom('1.1.0.2');
	api.use('ecmascript');
	api.use(['caoliao:lib'], 'server');
	api.use(['coffeescript@1.0.11'], 'server');
	api.use(['routepolicy@1.0.6', 'webapp@1.2.3', 'underscore@1.0.4', 'service-configuration@1.0.5'], 'server');
	api.use(['http@1.1.1', 'accounts-base@1.2.3-beta.16'], ['client', 'server']);

	api.add_files(['saml_server.js', 'saml_utils.js'], 'server');
	api.add_files(['saml_caoliao.coffee'], 'server');
	api.add_files('saml_client.js', 'client');
});

Npm.depends({
	'xml2js': '0.2.0',
	'xml-crypto': '0.6.0',
	'xmldom': '0.1.19',
	'connect': '2.7.10',
	'xmlbuilder': '2.6.4',
	'querystring': '0.2.0',
	'xml-encryption': '0.7.2'
});
