Package.describe({
	name: 'caoliao:emojione',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate emojis',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('ecmascript');
	api.use([
		'coffeescript@1.0.11',
		'emojione:emojione@2.1.4',
		'caoliao:lib'
	]);
	api.use('caoliao:theme');
	api.use('caoliao:ui-message');

	api.use('reactive-var@1.0.6');
	api.use('templating@1.1.5');
	api.use('ecmascript');
	api.use('less@2.5.1');

	api.addFiles('emojione.coffee', ['server', 'client']);
	api.addFiles('caoliao.coffee', 'client');

	api.addFiles('emojiPicker.html', 'client');
	api.addFiles('emojiPicker.js', 'client');

	api.addAssets('emojiPicker.less', 'server');
	api.addFiles('loadStylesheet.js', 'server');

	api.addFiles('lib/EmojiPicker.js', 'client');
	api.addFiles('emojiButton.js', 'client');

	api.addFiles('sprites.css', 'client');
});
