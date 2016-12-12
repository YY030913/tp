Package.describe({
	name: 'caoliao:ui',
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

	api.use('kadira:flow-router@2.10.1', 'client');
	api.use('reactive-var@1.0.6');
	api.use('tracker@1.0.9');
	api.use('webapp@1.2.3');

	api.use([
		'accounts-base@1.2.2',
		'mongo@1.1.3',
		'session@1.1.1',
		'jquery@1.11.4',
		'tracker@1.0.9',
		'reactive-var@1.0.6',
		'ecmascript',
		'templating@1.1.5',
		'coffeescript@1.0.11',
		'underscore@1.0.4',
		'caoliao:lib',
		'konecty:user-presence',
		// 'caoliao:alogs',
		'raix:push@3.0.2',
		'raix:ui-dropped-event@0.0.7',
		'chrismbeckett:toastr@2.1.2_1',
		'caoliao:pullrefresh',
		// 'fortawesome:fontawesome@4.5.0'
	]);


	// LIB FILES
	api.addFiles('lib/getAvatarUrlFromUsername.coffee');
	api.addFiles('lib/accountBox.coffee', 'client');
	api.addFiles('lib/accounts.coffee', 'client');
	api.addFiles('lib/avatar.coffee', 'client');
	api.addFiles('lib/chatMessages.coffee', 'client');
	api.addFiles('lib/collections.coffee', 'client');
	api.addFiles('lib/constallation.js', 'client');
	api.addFiles('lib/customEventPolyfill.js', 'client');
	api.addFiles('lib/fileUpload.coffee', 'client');
	api.addFiles('lib/fireEvent.coffee', 'client');
	api.addFiles('lib/jquery.swipebox.min.js', 'client');
	api.addFiles('lib/menu.coffee', 'client');
	api.addFiles('lib/modal.coffee', 'client');
	api.addFiles('lib/Modernizr.js', 'client');
	api.addFiles('lib/msgTyping.coffee', 'client');
	api.addFiles('lib/notification.coffee', 'client');
	api.addFiles('lib/parentTemplate.js', 'client');
	api.addFiles('lib/particles.js', 'client');
	api.addFiles('lib/readMessages.coffee', 'client');
	api.addFiles('lib/rocket.coffee', 'client');
	api.addFiles('lib/RoomHistoryManager.coffee', 'client');
	api.addFiles('lib/RoomManager.coffee', 'client');
	api.addFiles('lib/sideNav.coffee', 'client');
	api.addFiles('lib/tapi18n.coffee', 'client');
	api.addFiles('lib/textarea-autogrow.js', 'client');

	// LIB CORDOVA
	api.addFiles('lib/cordova/facebook-login.coffee', 'client');
	api.addFiles('lib/cordova/keyboard-fix.coffee', 'client');
	api.addFiles('lib/cordova/push.coffee', 'client');
	api.addFiles('lib/cordova/urls.coffee', 'client');
	api.addFiles('lib/cordova/user-state.coffee', 'client');

	// LIB RECORDERJS
	api.addFiles('lib/recorderjs/audioRecorder.coffee', 'client');
	api.addFiles('lib/recorderjs/recorder.js', 'client');

	// LIB CLIPBOARDJS
	api.addFiles('lib/clipboardjs/clipboard.js', 'client');

	// TEXTAREA CURSOR MANAGEMENT
	api.addFiles('lib/textarea-cursor/set-cursor-position.js', 'client');

	// TEMPLATE FILES
	
	api.addFiles('views/cmsPage.html', 'client');
	api.addFiles('views/fxos.html', 'client');
	api.addFiles('views/modal.html', 'client');
	api.addFiles('views/404/debateNotFound.html', 'client');
	api.addFiles('views/404/roomNotFound.html', 'client');
	api.addFiles('views/404/invalidSecretURL.html', 'client');
	api.addFiles('views/app/headerOptsDropdown.html', 'client');
	api.addFiles('views/app/audioNotification.html', 'client');
	api.addFiles('views/app/burger.html', 'client');
	api.addFiles('views/app/home.html', 'client');
	api.addFiles('views/app/notAuthorized.html', 'client');
	api.addFiles('views/app/pageContainer.html', 'client');
	api.addFiles('views/app/pageSettingsContainer.html', 'client');
	api.addFiles('views/app/privateHistory.html', 'client');
	api.addFiles('views/app/room.html', 'client');
	api.addFiles('views/app/roomSearch.html', 'client');
	api.addFiles('views/app/secretURL.html', 'client');
	api.addFiles('views/app/userSearch.html', 'client');
	api.addFiles('views/app/spotlight/spotlight.html', 'client');
	api.addFiles('views/app/videoCall/videoButtons.html', 'client');
	api.addFiles('views/app/videoCall/videoCall.html', 'client');
	api.addFiles('views/app/notification.html', 'client');
	api.addFiles('views/app/shareModal.html', 'client');
	api.addFiles('views/app/loginFormModal.html', 'client');
	api.addFiles('views/app/socialShare.html', 'client');
	
	

	api.addFiles('views/cmsPage.coffee', 'client');
	api.addFiles('views/fxos.coffee', 'client');
	api.addFiles('views/modal.coffee', 'client');
	api.addFiles('views/404/roomNotFound.coffee', 'client');
	api.addFiles('views/app/burger.coffee', 'client');
	api.addFiles('views/app/home.coffee', 'client');
	api.addFiles('views/app/privateHistory.coffee', 'client');
	api.addFiles('views/app/room.coffee', 'client');
	api.addFiles('views/app/roomSearch.coffee', 'client');
	api.addFiles('views/app/secretURL.coffee', 'client');
	api.addFiles('views/app/spotlight/mobileMessageMenu.coffee', 'client');
	api.addFiles('views/app/spotlight/spotlight.coffee', 'client');
	api.addFiles('views/app/videoCall/videoButtons.coffee', 'client');
	api.addFiles('views/app/videoCall/videoCall.coffee', 'client');
	api.addFiles('views/app/notification.coffee', 'client');
	api.addFiles('views/app/shareModal.coffee', 'client');
	api.addFiles('views/app/loginFormModal.coffee', 'client');
	api.addFiles('views/app/socialShare.coffee', 'client');


	// TAPi18n
	// var _ = Npm.require('underscore');
	// var fs = Npm.require('fs');
	// var tapi18nFiles = _.compact(_.map(fs.readdirSync('packages/caoliao-lib/i18n'), function(filename) {
	// 	if (filename.indexOf('.json') > -1 && fs.statSync('packages/caoliao-lib/i18n/' + filename).size > 16) {
	// 		return 'i18n/' + filename;
	// 	}
	// }));
	// api.addFiles(tapi18nFiles);

	// api.use('tap:i18n');
	// api.imply('tap:i18n');
});
