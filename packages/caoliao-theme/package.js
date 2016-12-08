Package.describe({
	name: 'caoliao:theme',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');

	api.use('ecmascript');
	api.use('caoliao:lib');
	api.use('caoliao:logger');
	api.use('coffeescript@1.0.11');
	api.use('underscore@1.0.4');
	api.use('webapp@1.2.3');
	api.use('webapp-hashing@1.0.5');
	api.use('jquery@1.11.9');

	api.use('templating@1.1.5', 'client');


	api.addFiles('server/server.coffee', 'server');
	api.addFiles('server/variables.coffee', 'server');

	api.addFiles('client/minicolors/jquery.minicolors.css', ['client']);
	api.addFiles('client/minicolors/jquery.minicolors.js', ['client']);

	// 下拉加载
	// api.addFiles('client/dropload/dropload.css', ['client']);
	// api.addFiles('client/dropload/dropload.js', ['client']);

	// touch-slidtab
	api.addFiles('client/hammer.js', ['client']);
	// api.addFiles('client/jquery.hammer.js', ['client']);
	// api.addFiles('client/touch-emulator.js', ['client']);
	// api.addFiles('client/main.js', ['client']);

	// material-input
	// api.addFiles('client/materialForm.js', ['client']);

	// material-button
	// api.addFiles('client/materialButton.js', ['client']);

	api.addAssets('assets/fonts/fontello.eot', ['client']);
	api.addAssets('assets/fonts/fontello.ttf', ['client']);
	api.addAssets('assets/fonts/fontello.woff', ['client']);
	api.addAssets('assets/fonts/fontello.woff2', ['client']);

	api.addAssets('assets/fonts/icomoon.eot', ['client']);
	api.addAssets('assets/fonts/icomoon.ttf', ['client']);
	api.addAssets('assets/fonts/icomoon.woff', ['client']);
	api.addAssets('assets/fonts/icomoon.svg', ['client']);
	

	api.addAssets('client/fonts/roboto/Roboto-Bold.eot', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Bold.ttf', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Bold.woff', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Bold.woff2', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Light.eot', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Light.ttf', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Light.woff', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Light.woff2', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Medium.eot', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Medium.ttf', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Medium.woff', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Medium.woff2', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Regular.eot', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Regular.ttf', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Regular.woff', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Regular.woff2', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Thin.eot', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Thin.ttf', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Thin.woff', ['client']);
	api.addAssets('client/fonts/roboto/Roboto-Thin.woff2', ['client']);

	api.addAssets('assets/stylesheets/global/_variables.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_colors.import.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_keyframes.import.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_lesshat.import.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_preloader.import.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_reset.import.less', ['server']);
	api.addAssets('assets/stylesheets/utils/_chatops.less', ['server']);
	api.addAssets('assets/stylesheets/rtl.less', ['server']);
	api.addAssets('assets/stylesheets/base.less', ['server']);


	api.addFiles('assets/stylesheets/animation.css', ['client']);
	api.addFiles('assets/stylesheets/animate.min.css', ['client']);
	api.addFiles('assets/stylesheets/fontello.css', ['client']);
	api.addFiles('assets/stylesheets/swipebox.min.css', ['client']);
	api.addFiles('assets/stylesheets/customer.css', ['client']);
	api.addFiles('assets/stylesheets/flag-icon.css', ['client']);

	var _ = Npm.require('underscore');
	var fs = Npm.require('fs');
	var flagFiles = _.compact(_.map(fs.readdirSync('packages/caoliao-theme/assets/flags/4x3'), function(filename) {

		if (filename.indexOf('.svg') > -1 && fs.statSync('packages/caoliao-theme/assets/flags/4x3/' + filename).size > 16) {
			return 'assets/flags/4x3/' + filename;
		}
	}));
	api.addAssets(flagFiles, 'client');

	var flagFiles = _.compact(_.map(fs.readdirSync('packages/caoliao-theme/assets/flags/1x1'), function(filename) {

		if (filename.indexOf('.svg') > -1 && fs.statSync('packages/caoliao-theme/assets/flags/1x1/' + filename).size > 16) {
			return 'assets/flags/1x1/' + filename;
		}
	}));
	api.addAssets(flagFiles, 'client');
});

Npm.depends({
	'less': 'https://github.com/meteor/less.js/tarball/8130849eb3d7f0ecf0ca8d0af7c4207b0442e3f6',
	'less-plugin-autoprefix': '1.4.2'
});
