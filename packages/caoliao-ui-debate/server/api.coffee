#multer = Npm.require('multer');
#formidable = Npm.require('formidable');

qiniu = Npm.require('qiniu');
fiber = Npm.require('fibers');
#需要填写你的 Access Key 和 Secret Key
qiniu.conf.ACCESS_KEY = '38r8ofsGSxGUBDroPuG-nARcI0Hgpxh_PWAgEtw6';
qiniu.conf.SECRET_KEY = 'nLw07k_X6D17JnflH0tNbFx7yfijskZ1m3hi1_2n';

# slove 1
#multipart = Npm.require('connect-multiparty');

# slove 2
multiparty = Npm.require('multiparty');
onFinished = Npm.require('on-finished');
qs = Npm.require('qs');
typeis = Npm.require('type-is');

multipart = (req, res, next) ->
	if req._body
		return next();
	req.body = req.body || {};
	req.files = req.files || {};

	# ignore GET
	if 'GET' == req.method || 'HEAD' == req.method
		return next();

	# check Content-Type
	if !typeis(req, 'multipart/form-data') 
		return next();

	req._body = true;

	# parse
	form = new multiparty.Form(options);
	data = {};
	files = {};
	done = false;

	ondata = (name, val, data) ->
		if Array.isArray(data[name])
			data[name].push(val);
		else if data[name]
			data[name] = [data[name], val];
		else
			data[name] = val;

	form.on('field', (name, val) ->
		ondata(name, val, data);
	);

	form.on('file', (name, val) ->
		val.name = val.originalFilename;
		val.type = val.headers['content-type'] || null;
		ondata(name, val, files);
	);

	form.on('error', (err) ->
		if done 
			return;

		done = true;
		err.status = 400;

		if !req.readable 
			return next(err);

		req.resume();
		onFinished(req, () ->
			next(err);
		);
	);

	form.on('close', () ->
		if done
			return;

		done = true;

		try
			req.body = qs.parse(data);
			req.files = qs.parse(files);
			next();
		catch err
			err.status = 400;
			next(err);
	);

	form.parse(req);


#构建上传策略函数
uptoken = (bucket, key) ->
  putPolicy = new qiniu.rs.PutPolicy(bucket+":"+key);
  return putPolicy.token();

Api = new Restivus
	enableCors: true
	apiPath: 'api/'

Api.addRoute 'uptoken', authRequired: false,
	get: ->
		try
			uptoken = new qiniu.rs.PutPolicy("debateimgs");
			token = uptoken.token();
			if token 
				return CaoLiao.API.v1.success
					ts: Date.now()
					"Cache-Control": "max-age=0, private, must-revalidate"
					Pragma: "no-cache"
					Expires: 0
					uptoken: token

			
		catch e
			return CaoLiao.API.v1.failure e.error

Api.addRoute 'roomuptoken', authRequired: false,
	get: ->
		try
			uptoken = new qiniu.rs.PutPolicy("roomimgs");
			token = uptoken.token();
			if token 
				return CaoLiao.API.v1.success
					ts: Date.now()
					"Cache-Control": "max-age=0, private, must-revalidate"
					Pragma: "no-cache"
					Expires: 0
					uptoken: token

			
		catch e
			return CaoLiao.API.v1.failure e.error
###
WebApp.connectHandlers.use(multer({
			dest: './uploads/',
			rename: (fieldname, filename) ->
				return filename + Date.now();
			,
			onFileUploadStart: (file) ->
				console.log(file.originalname + ' is starting ...');
			,
			onFileUploadComplete: (file) ->
				console.log(file.fieldname + ' uploaded to  ' + file.path);
				fileName = file.name;
				done = true;
		}))
###
#multipartMiddleware = multipart();

#WebApp.connectHandlers.use multipartMiddleware

#WebApp.connectHandlers.use (req, res, next) => 
	#console.log("multipart", req.body);

WebApp.connectHandlers.use("/uploadDebateImg", (req, res, next) ->
	try
		multipart req, res, next
		console.log("upload", req.body);
		###
		form = new formidable.IncomingForm();
		form.parse(req, (err, fields, files) ->
		###
		file = req.files['wangEditorMobileFile'];
		if file?
			tempfilepath = file.path;
			type = file.type;
			filename = file.name;
			if filename.lastIndexOf('.') >= 0
				extname = filename.slice(filename.lastIndexOf('.') - filename.length)
			else
				extname = '';

			if extname == '' && type.indexOf('/') >= 0
				extname = '.' + type.split('/')[1];
			
			filename = Math.random().toString().slice(2) + extname;

			console.log "filename",filename
			#要上传的空间
			bucket = 'debateimgs';

			suff = file.name.substr(file.name.lastIndexOf('.'), file.name.length);
			#上传到七牛后保存的文件名
			key = new Date().getTime() + extname;
			extra = new qiniu.io.PutExtra();
			extra.mimeType = file.type;

			#生成上传 Token
			token = uptoken(bucket, key);


			qiniu.io.putFile(token, key, tempfilepath, extra, (err, ret) ->
				if err
					console.log "error",err
					throw new Meteor.Error(601, err);
				else
					res.writeHead(200);
					res.end("http://o8rnbrutf.bkt.clouddn.com/#{ret.key}");
			);
		else
			res.writeHead(200);
			res.end("error: no catch file!");
	catch e
		res.writeHead(200);
		res.end("error: no catch file req!");
		return
);
