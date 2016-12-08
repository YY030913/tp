Package.describe({
	name: 'caoliao:sharedsecret',
	version: '0.0.1',
	summary: 'CaoLiao libraries',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'caoliao:lib'
	]);

	api.use(['jparker:crypto-aes'], ['server', 'client']);

	api.addFiles('sharedsecret.coffee', ['server', 'client']);
});
