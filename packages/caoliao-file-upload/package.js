/* globals Package */
Package.describe({
	name: 'caoliao:file-upload',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: null
});



Package.onUse(function(api) {
	api.versionsFrom('1.2.1');
	api.use('ecmascript');
	api.use('caoliao:file');
	api.use('jalik:ufs@0.5.5');
	api.use('jalik:ufs-local@0.2.5');
	api.use('edgee:slingshot@0.7.1');
	// api.use('peerlibrary:aws-sdk@2.2.42_1');
	api.use('caoliao:lib');
	api.use('caoliao:qiniu');
	api.use('random@1.0.5');
	api.use('underscore@1.0.4');
	api.use('tracker@1.0.9');
	api.use('webapp@1.2.3');

	api.addFiles('globalFileRestrictions.js');

	// commom lib
	api.addFiles('lib/FileUpload.js');
	api.addFiles('lib/FileUploadBase.js');

	api.addFiles('client/lib/FileUploadFileSystem.js', 'client');
	api.addFiles('client/lib/fileUploadHandler.js', 'client');
	// api.addFiles('client/lib/FileUploadAmazonS3.js', 'client');
	api.addFiles('client/lib/FileUploadQiNiu.js', 'client');
	api.addFiles('client/lib/FileUploadGridFS.js', 'client');

	api.addFiles('server/lib/FileUpload.js', 'server');
	api.addFiles('server/lib/requests.js', 'server');

	// api.addFiles('server/config/configFileUploadAmazonS3.js', 'server');
	api.addFiles('server/config/configFileUploadQiNiu.js', 'server');
	api.addFiles('server/config/configFileUploadFileSystem.js', 'server');
	api.addFiles('server/config/configFileUploadGridFS.js', 'server');

	api.addFiles('server/methods/sendFileMessage.js', 'server');

	api.addFiles('server/startup/settings.js', 'server');

	api.export('fileUploadHandler');
	api.export('FileUpload');
});
