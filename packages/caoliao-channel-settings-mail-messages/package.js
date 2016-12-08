Package.describe({
	name: 'caoliao:channel-settings-mail-messages',
	version: '0.0.1',
	summary: 'Channel Settings - Mail Messages',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.4.0.1');
	api.use('ecmascript');

	api.use([
		'coffeescript@1.0.11',
		'templating@1.1.5',
		'reactive-var@1.0.6',
		'less@2.5.0',
		'caoliao:lib',
		'caoliao:channel-settings',
		'momentjs:moment@2.13.1'
	]);

	api.addFiles([
		'client/lib/startup.coffee',
		'client/stylesheets/mail-messages.less',
		'client/views/channelSettingsMailMessages.html',
		'client/views/channelSettingsMailMessages.coffee',
		'client/views/mailMessagesInstructions.html',
		'client/views/mailMessagesInstructions.coffee'
	], 'client');


	api.addFiles([
		'server/lib/startup.coffee',
		'server/methods/mailMessages.coffee'
	], 'server');
});
