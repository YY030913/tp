/* globals Slingshot, FileUpload, AWS, SystemLogger */
var crypto = Npm.require('crypto');

var QiNiuaccessKey, QiNiusecretKey;

var generateURL = function(file) {
	if (!file || !file.qiniu) {
		return;
	}
	let resourceURL = '/' + file.qiniu.bucket + '/' + file.qiniu.path + file._id;
	let expires = parseInt(new Date().getTime() / 1000) + 60;
	let StringToSign = 'GET\n\n\n' + expires +'\n'+resourceURL;
	let signature = crypto.createHmac('sha1', QiNiusecretKey).update(new Buffer(StringToSign, 'utf-8')).digest('base64');
	return file.url + '?AWSAccessKeyId='+encodeURIComponent(QiNiuaccessKey)+'&Expires='+expires+'&Signature='+encodeURIComponent(signature);
};


FileUpload.addHandler('qiniu', {
	get(file, req, res) {
		//构建bucketmanager对象
		var client = new qiniu.rs.Client();

		//你要测试的空间， 并且这个key在你空间中存在
		bucket = file.qiniu.bucket;
		key = file._id;

		//获取文件信息
		client.stat(bucket, key, function(err, ret) {
			if (!err) {
				console.log(ret.hash, ret.fsize, ret.putTime, ret.mimeType);
			} else {
				console.log(err);
			}
		});

		// let fileUrl = generateURL(file);

		// if (fileUrl) {
		// 	res.setHeader('Location', fileUrl);
		// 	res.writeHead(302);
		// }
		// res.end();
	},
	delete(file) {

		//构建bucketmanager对象
		var client = new qiniu.rs.Client();

		//你要测试的空间， 并且这个key在你空间中存在
		bucket = file.qiniu.bucket;
		key = file._id;

		//删除资源
		client.remove(bucket, key, function(err, ret) {
			if (!err) {
				// ok
			} else {
				console.log(err);
			}
		});

		// let qiniu = new AWS.QiNiu();
		// let request = qiniu.deleteObject({
		// 	Bucket: file.qiniu.bucket,
		// 	Key: file.qiniu.path + file._id
		// });
		// request.send();
	}
});

var createQiNiuDirective = _.debounce(() => {
	var directiveName = 'caoliao-uploads';

	var type = CaoLiao.settings.get('FileUpload_Storage_Type');
	var bucket = CaoLiao.settings.get('FileUpload_QiNiu_Bucket');
	// var acl = CaoLiao.settings.get('FileUpload_QiNiu_Acl');
	var accessKey = CaoLiao.settings.get('FileUpload_QiNiu_AccessKey');
	var secretKey = CaoLiao.settings.get('FileUpload_QiNiu_SecretKey');
	// var cdn = CaoLiao.settings.get('FileUpload_QiNiu_CDN');
	// var region = CaoLiao.settings.get('FileUpload_QiNiu_Region');
	var bucketUrl = CaoLiao.settings.get('FileUpload_QiNiu_BucketURL');

	// QiNiu.config.update({
	// 	accessKey: CaoLiao.settings.get('FileUpload_QiNiu_AccessKey'),
	// 	secretKey: CaoLiao.settings.get('FileUpload_QiNiu_SecretKey')
	// });

	if (type === 'QiNiu' && !_.isEmpty(bucket) && !_.isEmpty(accessKey) && !_.isEmpty(secretKey)) {
		// if (Slingshot._directives[directiveName]) {
		// 	delete Slingshot._directives[directiveName];
		// }
		var config = {
			bucket: bucket,
			AccessKey: accessKey,
			SecretKey: secretKey,
			key: function(file, metaContext) {
				var path = CaoLiao.hostname + '/' + metaContext.rid + '/' + this.userId + '/';

				let upload = {
					qiniu: {
						bucket: bucket,
						// region: region,
						path: path
					}
				};
				let fileId = CaoLiao.models.Uploads.insertFileInit(metaContext.rid, this.userId, 'qiniu', file, upload);

				return path + fileId;
			}
		};

		// if (!_.isEmpty(acl)) {
		// 	config.acl = acl;
		// }

		// if (!_.isEmpty(cdn)) {
		// 	config.cdn = cdn;
		// }

		// if (!_.isEmpty(region)) {
		// 	config.region = region;
		// }

		if (!_.isEmpty(bucketUrl)) {
			config.bucketUrl = bucketUrl;
		}

		// try {
		// 	Slingshot.createDirective(directiveName, Slingshot.QiNiuStorage, config);
		// } catch (e) {
		// 	SystemLogger.error('Error configuring QiNiu ->', e.message);
		// }
	} //else if (Slingshot._directives[directiveName]) {
		// delete Slingshot._directives[directiveName];
	// }
}, 500);

CaoLiao.settings.get('FileUpload_Storage_Type', createQiNiuDirective);

CaoLiao.settings.get('FileUpload_QiNiu_Bucket', createQiNiuDirective);

// CaoLiao.settings.get('FileUpload_QiNiu_Acl', createQiNiuDirective);

CaoLiao.settings.get('FileUpload_QiNiu_AccessKey', function(key, value) {
	QiNiuaccessKey = value;
	createQiNiuDirective();
});

CaoLiao.settings.get('FileUpload_QiNiu_SecretAccessKey', function(key, value) {
	QiNiusecretKey = value;
	createQiNiuDirective();
});

// CaoLiao.settings.get('FileUpload_QiNiu_CDN', createQiNiuDirective);

// CaoLiao.settings.get('FileUpload_QiNiu_Region', createQiNiuDirective);

CaoLiao.settings.get('FileUpload_QiNiu_BucketURL', createQiNiuDirective);
