Package.describe({
	name: 'caoliao:ui-message',
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

	api.use([
		'mongo@1.1.3',
		'ecmascript',
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'tracker@1.0.9',
		'caoliao:lib'
	]);

	api.addFiles('message/message.html', 'client');
	api.addFiles('message/messageBox.html', 'client');
	api.addFiles('message/messageDropdown.html', 'client');
	api.addFiles('message/popup/messagePopup.html', 'client');
	api.addFiles('message/popup/messagePopupChannel.html', 'client');
	api.addFiles('message/popup/messagePopupConfig.html', 'client');
	api.addFiles('message/popup/messagePopupEmoji.html', 'client');
	api.addFiles('message/popup/messagePopupSlashCommand.html', 'client');
	api.addFiles('message/popup/messagePopupUser.html', 'client');
	api.addFiles('message/messageList.html', 'client');
	
	api.addFiles('message/message.coffee', 'client');
	api.addFiles('message/messageBox.coffee', 'client');
	api.addFiles('message/popup/messagePopup.coffee', 'client');
	api.addFiles('message/popup/messagePopupConfig.coffee', 'client');
	api.addFiles('message/popup/messagePopupEmoji.coffee', 'client');
	api.addFiles('message/messageList.coffee', 'client');

	api.addFiles('message/renderMessageBody.js', 'client');

	api.export('renderMessageBody');
});
