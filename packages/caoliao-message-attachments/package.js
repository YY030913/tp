Package.describe({
	name: 'caoliao:message-attachments',
	version: '0.0.1',
	summary: 'Widget for message attachments',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use([
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib'
	]);

	api.addFiles('client/messageAttachment.html', 'client');
	api.addFiles('client/messageAttachment.coffee', 'client');

	// stylesheets
	api.addAssets('client/stylesheets/messageAttachments.less', 'server');
	api.addFiles('client/stylesheets/loader.coffee', 'server');
});
