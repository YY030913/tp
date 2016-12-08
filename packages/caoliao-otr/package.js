Package.describe({
	name: 'caoliao:otr',
	version: '0.0.1',
	summary: 'Off-the-record messaging for CaoLiao',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');


	api.use([
		'ecmascript',
		'less@2.5.0',
		'caoliao:lib',
		'tracker@1.0.9',
		'reactive-var@1.0.6'
	]);

	api.use('templating@1.1.5', 'client');

	api.addFiles([
		'client/caoliao.otr.js',
		'client/caoliao.otr.room.js',
		'client/stylesheets/otr.less',
		'client/views/otrFlexTab.html',
		'client/views/otrFlexTab.js',
		'client/tabBar.js'
	], 'client');

	api.addFiles([
		'server/settings.js',
		'server/models/Messages.js',
		'server/methods/deleteOldOTRMessages.js',
		'server/methods/updateOTRAck.js'
	], 'server');
});
