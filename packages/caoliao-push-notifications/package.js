Package.describe({
	name: 'caoliao:push-notifications',
	version: '0.0.1',
	summary: 'Push Notifications Settings',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use([
		'ecmascript',
		'underscore@1.0.4',
		'less@2.5.0',
		'caoliao:lib'
	]);

	api.use('templating@1.1.5', 'client');

	api.addFiles([
		'client/stylesheets/pushNotifications.less',
		'client/views/pushNotificationsFlexTab.html',
		'client/views/pushNotificationsFlexTab.js',
		'client/tabBar.js'
	], 'client');

	api.addFiles([
		'server/methods/saveNotificationSettings.js',
		'server/models/Subscriptions.js'
	], 'server');
});
