Package.describe({
	name: 'caoliao:ui-chat',
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

	api.use('reactive-var@1.0.6');
	api.use('tracker@1.0.9');
	api.use('underscore@1.0.4');
	api.use('templating@1.1.5', 'client');
	api.use('kadira:flow-router@2.10.1', 'client');
	api.use([
		'ecmascript',
		'jquery@1.11.4',
		'caoliao:lib',
		'caoliao:ui']);
	api.use('coffeescript@1.0.11');

	api.addFiles('client/lib/route.coffee', 'client');

	api.addFiles('client/views/chat.html', 'client');
	api.addFiles('client/views/chatChannel.html', 'client');
	api.addFiles('client/views/chatUserItem.html', 'client');
	
	api.addFiles('client/views/chat.coffee', 'client');
	api.addFiles('client/views/chatChannel.coffee', 'client');
	api.addFiles('client/views/chatUserItem.coffee', 'client');

	api.addFiles('client/stylesheets/chatList.css', 'client');
	// api.addAssets('styles/side-nav.less', 'client');
});
