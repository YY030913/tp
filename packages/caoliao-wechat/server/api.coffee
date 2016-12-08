Api = new Restivus
	enableCors: true
	apiPath: 'api/'

config = 
	token: 'CaoLiao',
	appid: 'wx0ed57f40d3575ef7',
	encodingAESKey: 'LByyjgEakKJrmYe4Nw7fPX6TvBZPO8BBbIPqoXGaVIk'
	# secretKey: '0eda9774836ee729111384e3380c7b26'

Weixin.token = config.token;
Weixin.appid = config.appid;
Weixin.encodingAESKey = config.encodingAESKey;

Weixin.textMsg (msg)->
	resMsg =
		fromUserName : msg.toUserName,
		toUserName : msg.fromUserName,
		msgType : "news",
		articles : articles,
		funcFlag : 0
	Weixin.sendMsg(resMsg);

# 监听图片消息
Weixin.imageMsg (msg) ->
	console.log("imageMsg received");
	console.log(JSON.stringify(msg));


# 监听语音消息
Weixin.voiceMsg (msg) ->
	console.log("voiceMsg received");
	console.log(JSON.stringify(msg));


# 监听位置消息
Weixin.locationMsg (msg) ->
	console.log("locationMsg received");
	console.log(JSON.stringify(msg));


# 监听链接消息
Weixin.urlMsg (msg) ->
	console.log("urlMsg received");
	console.log(JSON.stringify(msg));


# 监听事件消息
Weixin.eventMsg (msg) ->
	console.log("eventMsg received");
	console.log(JSON.stringify(msg));

Api.addRoute 'wechat', authRequired: false,
	get: ->
		try
			check = Weixin.checkSignature(@.request)
			if check 
				@.response.write(@.request.query.echostr)
			else
				@.response.write("fail")
			this.done()
		catch e
			console.log e
			return CaoLiao.API.v1.failure e.error
	post: ->
		try
			#check = Weixin.checkSignature(@.request)
			Weixin.loop(@.request, @.response)
			
			@.done()
				
		catch e
			console.log e
			return CaoLiao.API.v1.failure e.error
	