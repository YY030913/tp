/* globals Slingshot, FileUpload, AWS, SystemLogger */
var crypto = Npm.require('crypto');

var S3accessKey, S3secretKey;

var generateURL = function(file) {
	if (!file || !file.s3) {
		return;
	}
	let resourceURL = '/' + file.s3.bucket + '/' + file.s3.path + file._id;
	let expires = parseInt(new Date().getTime() / 1000) + 60;
	let StringToSign = 'GET\n\n\n' + expires +'\n'+resourceURL;
	let signature = crypto.createHmac('sha1', S3secretKey).update(new Buffer(StringToSign, 'utf-8')).digest('base64');
	return file.url + '?AWSAccessKeyId='+encodeURIComponent(S3accessKey)+'&Expires='+expires+'&Signature='+encodeURIComponent(signature);
};

FileUpload.addHandler('s3', {
	get(file, req, res) {
		let fileUrl = generateURL(file);

		if (fileUrl) {
			res.setHeader('Location', fileUrl);
			res.writeHead(302);
		}
		res.end();
	},
	delete(file) {
		let s3 = new AWS.S3();
		let request = s3.deleteObject({
			Bucket: file.s3.bucket,
			Key: file.s3.path + file._id
		});
		request.send();
	}
});

var createS3Directive = _.debounce(() => {
	var directiveName = 'caoliao-uploads';

	var type = CaoLiao.settings.get('FileUpload_Storage_Type');
	var bucket = CaoLiao.settings.get('FileUpload_S3_Bucket');
	var acl = CaoLiao.settings.get('FileUpload_S3_Acl');
	var accessKey = CaoLiao.settings.get('FileUpload_S3_AWSAccessKeyId');
	var secretKey = CaoLiao.settings.get('FileUpload_S3_AWSSecretAccessKey');
	var cdn = CaoLiao.settings.get('FileUpload_S3_CDN');
	var region = CaoLiao.settings.get('FileUpload_S3_Region');
	var bucketUrl = CaoLiao.settings.get('FileUpload_S3_BucketURL');

	AWS.config.update({
		accessKeyId: CaoLiao.settings.get('FileUpload_S3_AWSAccessKeyId'),
		secretAccessKey: CaoLiao.settings.get('FileUpload_S3_AWSSecretAccessKey')
	});

	if (type === 'AmazonS3' && !_.isEmpty(bucket) && !_.isEmpty(accessKey) && !_.isEmpty(secretKey)) {
		if (Slingshot._directives[directiveName]) {
			delete Slingshot._directives[directiveName];
		}
		var config = {
			bucket: bucket,
			AWSAccessKeyId: accessKey,
			AWSSecretAccessKey: secretKey,
			key: function(file, metaContext) {
				var path = CaoLiao.hostname + '/' + metaContext.rid + '/' + this.userId + '/';

				let upload = {
					s3: {
						bucket: bucket,
						region: region,
						path: path
					}
				};
				let fileId = CaoLiao.models.Uploads.insertFileInit(metaContext.rid, this.userId, 's3', file, upload);

				return path + fileId;
			}
		};

		if (!_.isEmpty(acl)) {
			config.acl = acl;
		}

		if (!_.isEmpty(cdn)) {
			config.cdn = cdn;
		}

		if (!_.isEmpty(region)) {
			config.region = region;
		}

		if (!_.isEmpty(bucketUrl)) {
			config.bucketUrl = bucketUrl;
		}

		try {
			Slingshot.createDirective(directiveName, Slingshot.S3Storage, config);
		} catch (e) {
			SystemLogger.error('Error configuring S3 ->', e.message);
		}
	} else if (Slingshot._directives[directiveName]) {
		delete Slingshot._directives[directiveName];
	}
}, 500);

CaoLiao.settings.get('FileUpload_Storage_Type', createS3Directive);

CaoLiao.settings.get('FileUpload_S3_Bucket', createS3Directive);

CaoLiao.settings.get('FileUpload_S3_Acl', createS3Directive);

CaoLiao.settings.get('FileUpload_S3_AWSAccessKeyId', function(key, value) {
	S3accessKey = value;
	createS3Directive();
});

CaoLiao.settings.get('FileUpload_S3_AWSSecretAccessKey', function(key, value) {
	S3secretKey = value;
	createS3Directive();
});

CaoLiao.settings.get('FileUpload_S3_CDN', createS3Directive);

CaoLiao.settings.get('FileUpload_S3_Region', createS3Directive);

CaoLiao.settings.get('FileUpload_S3_BucketURL', createS3Directive);
