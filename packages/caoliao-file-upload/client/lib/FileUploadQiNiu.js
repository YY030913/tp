/* globals FileUpload, FileUploadBase, Slingshot */
var uploader = function(options) {

	let self = this;

	if (!options.file) {
		throw new TypeError('must have file profile');
	}

	let Qiniu_UploadUrl = "https://up.qbox.me/";
	var loaded = 0;
	var total = 0;
	let file = options.file;
	let uploading = false;


	options = _.extend({
		onComplete: uploader.prototype.onComplete,
		onStop: uploader.prototype.onStop
	})

	self.onComplete = options.onComplete;
	self.onStop = options.onStop;

	var Qiniu_upload = function(token) {
		uploading = true;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', Qiniu_UploadUrl, true);
        var formData, startDate;
        formData = new FormData();
        var extname, key, now;

		if (file.name.lastIndexOf('.') >= 0) {
			extname = file.name.slice(file.name.lastIndexOf('.') - file.name.length);
		} else {
			extname = '';
		}

		if (extname === '' && file.type.indexOf('/') >= 0) {
			extname = '.' + file.type.split('/')[1];
		}

		now = new Date();

		key = "roomIMG-" + Meteor.userId() + "-" + now.getTime() + extname;
        if (key !== null && key !== undefined) formData.append('key', key);
        formData.append('token', token);
        formData.append('file', file);
        var taking;
        xhr.upload.addEventListener("progress", function(evt) {
            if (evt.lengthComputable) {
                var nowDate = new Date().getTime();
                taking = nowDate - startDate;
                var x = (evt.loaded) / 1024;
                var y = taking / 1000;
                var uploadSpeed = (x / y);
                var formatSpeed;
                if (uploadSpeed > 1024) {
                    formatSpeed = (uploadSpeed / 1024).toFixed(2) + "Mb\/s";
                } else {
                    formatSpeed = uploadSpeed.toFixed(2) + "Kb\/s";
                }
                self.loaded = evt.loaded;
                self.total = evt.total;
                if (self.total == self.loaded) {
                	self.onComplete(file);
                }
            }
        }, false);

        xhr.onreadystatechange = function(response) {
            if (xhr.readyState == 4 && xhr.status == 200 && xhr.responseText != "") {
                var blkRet = JSON.parse(xhr.responseText);
                console && console.log(blkRet);
            } else if (xhr.status != 200 && xhr.responseText) {

            }
        };
        startDate = new Date().getTime();
        xhr.send(formData);
    }

	self.getProgress = function() {
		return Math.min((self.loaded / self.total) * 100 / 100, 1.0);
    };


    self.start = function(token) {
    	Qiniu_upload(token);
    }

    self.stop = function() {
    	if (uploading) {
            uploading = false;
            self.onStop(file);
        }
    }
}

uploader.prototype.onStop = function (file) {
};

uploader.prototype.onComplete = function (file) {
};

FileUpload.QiNiu = class FileUploadQiNiu extends FileUploadBase {
	
	constructor(meta, file, data) {

		console.log("FileUpload.QiNiu");
		console.log(arguments);
		super(meta, file, data);

		this.progress = 0;
		self = this;
		
		if (!file.name && meta.name) {
			file.name = meta.name;
		}

		this.handler = new uploader({
			"file": file,
			onComplete: function() {
				Meteor.call('sendFileMessage', this.meta.rid, null, file, () => {
					Meteor.setTimeout(() => {
						var uploading = Session.get('uploading');
						if (uploading != null) {
							let item = _.findWhere(uploading, {
								id: this.id
							});
							return Session.set('uploading', _.without(uploading, item));
						}
					}, 2000);
				});
			}
		});
	}

	start() {
		self = this;
		$.ajax({
			method: "get",
			url: "/api/roomuptoken",
			contentType: "application/json",
			success: function (data) {
				self.handler.start(data.uptoken);
			}
		});
	}

	getProgress() {
		return this.handler.getProgress();
	}

	stop() {
		this.handler.stop();
	}
};