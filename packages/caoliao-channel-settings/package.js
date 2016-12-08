Package.describe({
	name: 'caoliao:channel-settings',
	version: '0.0.1',
	summary: 'Channel Settings Panel',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.4.0.1');
	api.use('ecmascript');

	api.use([
		'coffeescript@1.0.11',
		'reactive-var@1.0.6',
		'tracker@1.0.9',
		'templating@1.1.5',
		'less@2.5.0',
		'caoliao:lib'
	]);

	api.addFiles([
		'client/lib/ChannelSettings.coffee',
		'client/startup/messageTypes.coffee',
		'client/startup/tabBar.coffee',
		'client/startup/trackSettingsChange.coffee',
		'client/views/channelSettings.html',
		'client/views/channelSettings.coffee',
		'client/stylesheets/channel-settings.less'
	], 'client');

	api.addFiles([
		'server/functions/saveRoomType.coffee',
		'server/functions/saveRoomTopic.coffee',
		'server/functions/saveRoomName.coffee',
		'server/methods/saveRoomSettings.coffee',
		'server/models/Messages.coffee'
	], 'server');
});
