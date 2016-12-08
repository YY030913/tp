CaoLiao.settings.addGroup('FileUpload', function() {
	this.add('FileUpload_Enabled', true, {
		type: 'boolean',
		public: true
	});

	this.add('FileUpload_MaxFileSize', 2097152, {
		type: 'int',
		public: true
	});

	this.add('FileUpload_MediaTypeWhiteList', 'image/*,audio/*,application/pdf,text/plain,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document', {
		type: 'string',
		public: true,
		i18nDescription: 'FileUpload_MediaTypeWhiteListDescription'
	});

	this.add('FileUpload_ProtectFiles', true, {
		type: 'boolean',
		public: true,
		i18nDescription: 'FileUpload_ProtectFilesDescription'
	});

	this.add('FileUpload_Storage_Type', 'QiNiu', {
		type: 'select',
		values: [ {
			key: 'QiNiu',
			i18nLabel: 'QiNiu'
		}, {
			key: 'GridFS',
			i18nLabel: 'GridFS'
		// }, {
		// 	key: 'AmazonS3',
		// 	i18nLabel: 'AmazonS3'
		}, {
			key: 'FileSystem',
			i18nLabel: 'FileSystem'
		}],
		public: true
	});

	// this.section('Amazon S3', function() {
	// 	this.add('FileUpload_S3_Bucket', '', {
	// 		type: 'string',
	// 		enableQuery: {
	// 			_id: 'FileUpload_Storage_Type',
	// 			value: 'AmazonS3'
	// 		}
	// 	});
	// 	this.add('FileUpload_S3_Acl', '', {
	// 		type: 'string',
	// 		enableQuery: {
	// 			_id: 'FileUpload_Storage_Type',
	// 			value: 'AmazonS3'
	// 		}
	// 	});
		// this.add('FileUpload_S3_AWSAccessKeyId', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'AmazonS3'
		// 	}
		// });
		// this.add('FileUpload_S3_AWSSecretAccessKey', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'AmazonS3'
		// 	}
		// });
		// this.add('FileUpload_S3_CDN', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'AmazonS3'
		// 	}
		// });
		// this.add('FileUpload_S3_Region', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'AmazonS3'
		// 	}
		// });
		// this.add('FileUpload_S3_BucketURL', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'AmazonS3'
		// 	},
		// 	i18nDescription: 'Override_URL_to_which_files_are_uploaded_This_url_also_used_for_downloads_unless_a_CDN_is_given.'
		// });
	// });


	this.section('QiNiu', function() {
		this.add('FileUpload_QiNiu_Bucket', 'caoliao', {
			type: 'string',
			enableQuery: {
				_id: 'FileUpload_Storage_Type',
				value: 'QiNiu'
			}
		});
		// this.add('FileUpload_QiNiu_Acl', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'QiNiu'
		// 	}
		// });
		this.add('FileUpload_QiNiu_AccessKey', '38r8ofsGSxGUBDroPuG-nARcI0Hgpxh_PWAgEtw6', {
			type: 'string',
			enableQuery: {
				_id: 'FileUpload_Storage_Type',
				value: 'QiNiu'
			}
		});
		this.add('FileUpload_QiNiu_SecretKey', 'nLw07k_X6D17JnflH0tNbFx7yfijskZ1m3hi1_2n', {
			type: 'string',
			enableQuery: {
				_id: 'FileUpload_Storage_Type',
				value: 'QiNiu'
			}
		});
		// this.add('FileUpload_QiNiu_CDN', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'QiNiu'
		// 	}
		// });
		// this.add('FileUpload_QiNiu_Region', '', {
		// 	type: 'string',
		// 	enableQuery: {
		// 		_id: 'FileUpload_Storage_Type',
		// 		value: 'QiNiu'
		// 	}
		// });
		this.add('FileUpload_QiNiu_BucketURL', 'http://odgwyxk4c.bkt.clouddn.com', {
			type: 'string',
			enableQuery: {
				_id: 'FileUpload_Storage_Type',
				value: 'QiNiu'
			},
			i18nDescription: 'Override_URL_to_which_files_are_uploaded_This_url_also_used_for_downloads_unless_a_CDN_is_given.'
		});
	});

	this.section('File System', function() {
		this.add('FileUpload_FileSystemPath', '', {
			type: 'string',
			enableQuery: {
				_id: 'FileUpload_Storage_Type',
				value: 'QiNiu'
			}
		});
	});
});
