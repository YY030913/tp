/* globals FileUpload, FileUploadBase, Slingshot */

FileUpload.QiNiu = class FileUploadQiNiu extends FileUploadBase {
	constructor(meta, file, data) {
		console.log("FileUpload.QiNiu")
		super(meta, file, data);

		progress = {}

		this.handler = new Qiniu.uploader({
			runtimes: 'html5,flash,html4',
			browse_button: "pickFile",
			uptoken_url: '/api/uptoken',
			domain: 'http://odgwyxk4c.bkt.clouddn.com/',
			// container: containerId,
			max_file_size: '20mb',
			flash_swf_url: '../js/plupload/Moxie.swf',
			filters: {
				mime_types: [
					{ title: "图片文件", extensions: "jpg,gif,png,bmp" }
				]
			},
			max_retries: 3,
			dragdrop: true,
			// drop_element: 'editor-container',
			chunk_size: '2mb',
			auto_start: false, 
			init: {
				'FilesAdded': function(up, files) {
					console.log("FilesAdded")
					plupload.each(files, function(file) {

					});
				},
				'BeforeUpload': function(up, file) {
					console.log("BeforeUpload")
				},
				'UploadProgress': function(up, file) {
					console.log("UploadProgress")

					progress = new FileProgress(file, 'fsUploadProgress');
					chunk_size = plupload.parseSize(this.getOption('chunk_size'));

					progress.setProgress(file.percent + "%", file.speed, chunk_size);
					// showUploadProgress(file.percent);
				},
				'FileUploaded': function(up, file, info) {
					console.log("FileUploaded")
					domain = up.getOption('domain');
					res = $.parseJSON(info);
					sourceLink = domain + res.key;
					console.log(sourceLink)
					// editor.command(null, 'insertHtml', '<img src="' + sourceLink + '" style="max-width:100%;"/>')
				},
				'Error': function(up, err, errTip) {
					toastr.error(t(err.message))
				},
				'UploadComplete': function(){
					console.log("UploadComplete")
					// hideUploadProgress();
				}
			}
		});

		this.handler.getProgress = function() {
			if(! _.isEmpty(progress)){
				return progress.getProgress();
			}
		}
	}
	start() {
		console.log("qiniu start")
		console.log(this.handler.init())
		return this.handler.start();
	}

	getProgress() {
		console.log("qiniu getProgress")
		return this.handler.getProgress();
	}

	stop() {
		console.log("qiniu stop")
		this.handler.stop();
	}
};
