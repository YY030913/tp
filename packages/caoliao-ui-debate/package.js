Package.describe({
	name: 'caoliao:ui-debate',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Npm.depends({
  'qiniu': '6.1.9',
  // slove 1
  // 'connect-multiparty': '2.0.0'

  // 'formidable': '1.0.17',
  // slove 2
  'multiparty': '4.1.2',
  'on-finished': '2.3.0',
  'qs': '4.0.0',
  'type-is': '1.6.4',
  // "multer": "1.2.0"
});



Package.onUse(function(api) {
	api.versionsFrom('1.2.1');

	api.use('reactive-var@1.0.6');
	api.use('tracker@1.0.9');
	api.use('webapp@1.2.3');
	api.use('templating@1.1.5', 'client');
	api.use('kadira:flow-router@2.10.1', 'client');

	api.use([
		'ecmascript',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib',
		'jquery@1.11.4',
		'caoliao:api',
		'caoliao:bosonnlp',
		// 'caoliao:parallaxscrollview',
		'caoliao:swiper',
		'caoliao:keyboardawarelistview',
		'caoliao:wangeditor',
		'caoliao:ui',
		'caoliao:ui-activity',
		// 'caoliao:ui-user',
		'nimble:restivus@0.8.10',
		'percolate:synced-cron',
		'caoliao:mobile-detect',
		// 'caoliao:summary',
		'caoliao:ui-activity',
		'caoliao:slider',
		'caoliao:autocontent',
		'caoliao:score',
		'caoliao:qrcode',
		'caoliao:qiniu',
		'caoliao:pullrefresh',
		// 'caoliao:react-native-swipeout',
		'sha@1.0.4'
	]);

	
	
	api.addFiles('server/api.coffee', 'server');
	// api.addFiles('server/connectMultiparty.js', 'server');
	api.addFiles('server/startup/startup.coffee', 'server');
	api.addFiles('server/startup/debateTagCron.coffee', 'server');

	api.addFiles('client/lib/collections.coffee', 'client');
	api.addFiles('client/lib/startup.coffee', 'client');
	api.addFiles('client/lib/DebatesManager.coffee', 'client');
	

	api.addFiles('client/route.coffee', 'client');

	api.addFiles('client/views/debate.html', 'client');
	api.addFiles('client/views/debateFlex.html', 'client')
	api.addFiles('client/views/debateProfile.html', 'client');
	api.addFiles('client/views/debateEdit.html', 'client');
	api.addFiles('client/views/debateTag.html', 'client');
	api.addFiles('client/views/debateItem.html', 'client');
	api.addFiles('client/views/debateCateConfirm.html', 'client');
	api.addFiles('client/views/popDebateTagInput.html', 'client');;
	api.addFiles('client/views/debates.html', 'client');
	api.addFiles('client/views/userDebates.html', 'client');
	api.addFiles('client/views/debateType.html', 'client');
	api.addFiles('client/views/typeDebates.html', 'client');
	
	api.addFiles('client/views/debate.coffee', 'client');
	api.addFiles('client/views/debateFlex.coffee', 'client');
	api.addFiles('client/views/debateProfile.coffee', 'client');
	api.addFiles('client/views/debateEdit.coffee', 'client');
	api.addFiles('client/views/debateTag.coffee', 'client');
	api.addFiles('client/views/debateItem.coffee', 'client');
	api.addFiles('client/views/debateCateConfirm.coffee', 'client');
	api.addFiles('client/views/popDebateTagInput.coffee', 'client');
	api.addFiles('client/views/debates.coffee', 'client');
	api.addFiles('client/views/userDebates.coffee', 'client');
	api.addFiles('client/views/debateType.coffee', 'client');
	api.addFiles('client/views/typeDebates.coffee', 'client');

	api.addFiles('client/stylesheets/debate.css', ['client']);

});
