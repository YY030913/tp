Package.describe({
	name: 'caoliao:internal-hubot',
	version: '0.0.1',
	summary: 'Internal Hubot for CaoLiao',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'tracker@1.0.9',
		'caoliao:lib'
	]);
	api.use('underscorestring:underscore.string@3.3.4');

	api.use('templating@1.1.5', 'client');

	api.addFiles([
		'hubot.coffee',
		'settings.coffee'
	], ['server']);

	api.export('Hubot', ['server']);
	api.export('HubotScripts', ['server']);
	api.export('InternalHubot', ['server']);
	api.export('InternalHubotReceiver', ['server']);
	api.export('CaoLiaoAdapter', ['server']);

});

Npm.depends({
	'coffee-script': '1.9.3',
	'hubot': '2.13.1',
	'hubot-scripts': '2.16.2',
	'hubot-help': '0.1.2'
});
