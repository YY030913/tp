isSubscribed = (_id) ->
	return ChatSubscription.find({ rid: _id }).count() > 0

Template.messageBox.helpers
	roomName: ->
		roomData = Session.get('roomData' + this._id)
		return '' unless roomData

		if roomData.t is 'd'
			return ChatSubscription.findOne({ rid: this._id }, { fields: { name: 1 } })?.name
		else
			return roomData.name
	showMarkdown: ->
		return CaoLiao.Markdown
	showHighlight: ->
		return CaoLiao.Highlight
	showKatex: ->
		return CaoLiao.katex
	showFormattingTips: ->
		return CaoLiao.settings.get('Message_ShowFormattingTips') and (CaoLiao.Markdown or CaoLiao.Highlight or CaoLiao.katex)
	canJoin: ->
		return !! ChatRoom.findOne { _id: @_id, t: 'c' }
	subscribed: ->
		return isSubscribed(this._id)
	getPopupConfig: ->
		template = Template.instance()
		return {
			getInput: ->
				return template.find('.input-message')
		}
	usersTyping: ->
		users = MsgTyping.get @_id
		if users.length is 0
			return
		if users.length is 1
			return {
				multi: false
				selfTyping: MsgTyping.selfTyping.get()
				users: users[0]
			}
		# usernames = _.map messages, (message) -> return message.u.username
		last = users.pop()
		if users.length > 4
			last = t('others')
		# else
		usernames = users.join(', ')
		usernames = [usernames, last]
		return {
			multi: true
			selfTyping: MsgTyping.selfTyping.get()
			users: usernames.join " #{t 'and'} "
		}
	fileUploadAllowedMediaTypes: ->
		return CaoLiao.settings.get('FileUpload_MediaTypeWhiteList')

	showMic: ->
		if not Template.instance().isMessageFieldEmpty.get()
			return

		if Template.instance().showMicButton.get()
			return 'show-mic'

	showSend: ->
		if not Template.instance().isMessageFieldEmpty.get() or not Template.instance().showMicButton.get()
			return 'show-send'

Template.messageBox.events
	'click .join': (event) ->
		event.stopPropagation()
		event.preventDefault()
		Meteor.call 'joinRoom', @_id

	'focus .input-message': (event) ->
		KonchatNotification.removeRoomNotification @_id

	'click .send-button': (event, instance) ->
		input = instance.find('.input-message')
		chatMessages[@_id].send(@_id, input, =>
			# fixes https://github.com/CaoLiao/CaoLiao/issues/3037
			# at this point, the input is cleared and ready for autogrow
			input.updateAutogrow()
			instance.isMessageFieldEmpty.set(chatMessages[@_id].isEmpty())
		)
		input.focus()

	'keyup .input-message': (event, instance) ->
		chatMessages[@_id].keyup(@_id, event, instance)
		instance.isMessageFieldEmpty.set(chatMessages[@_id].isEmpty())

	'paste .input-message': (e) ->
		if not e.originalEvent.clipboardData?
			return

		items = e.originalEvent.clipboardData.items
		files = []
		for item in items
			if item.kind is 'file' and item.type.indexOf('image/') isnt -1
				e.preventDefault()
				files.push
					file: item.getAsFile()
					name: 'Clipboard'

		if files.length > 0
			fileUpload files

	'keydown .input-message': (event) ->
		chatMessages[@_id].keydown(@_id, event, Template.instance())

	"click .editing-commands-cancel > button": (e) ->
		chatMessages[@_id].clearEditing()

	"click .editing-commands-save > button": (e) ->
		chatMessages[@_id].send(@_id, chatMessages[@_id].input)

	'change .message-form input[type=file]': (event, template) ->
		e = event.originalEvent or event
		files = e.target.files
		if not files or files.length is 0
			files = e.dataTransfer?.files or []

		filesToUpload = []
		for file in files
			filesToUpload.push
				file: file
				name: file.name

		fileUpload filesToUpload

	'click .message-form .mic': (e, t) ->
		AudioRecorder.start ->
			t.$('.stop-mic').removeClass('hidden')
			t.$('.mic').addClass('hidden')

	'click .message-form .stop-mic': (e, t) ->
		AudioRecorder.stop (blob) ->
			if CaoLiao.settings.get('FileUpload_Storage_Type') == "QiNiu"
				t.handler.get().addFile(blob, "#{TAPi18n.__('Audio record')}#{Meteor.userId()}#{(new Date()).getTime()}" + '.wav')
			else
				fileUpload [{
					file: blob
					type: 'audio'
					name: TAPi18n.__('Audio record') + '.wav'
				}]
		t.$('.stop-mic').addClass('hidden')
		t.$('.mic').removeClass('hidden')

Template.messageBox.onRendered ->
	instance = this
	instance.nooverride = true
	if CaoLiao.settings.get('FileUpload_Storage_Type') == "QiNiu"

		$("input[type=file]").attr("disabled", "disabled")

		btnId = 'upload' + Math.random().toString().slice(2);
		$(".message-buttons .icon-attach").attr('id', btnId);

		containerId = 'upload' + Math.random().toString().slice(2);
		$(".message-buttons.file").attr('id', containerId);

		uploadHandler = new Qiniu.uploader({
			runtimes: 'html5,flash,html4',
			browse_button: btnId,
			container: containerId,
			uptoken_url: '/api/roomuptoken',
			domain: 'http://ohfst9jc5.bkt.clouddn.com/',
			max_file_size: '20mb',
			flash_swf_url: '../js/plupload/Moxie.swf',
			filters: {
				mime_types: [
					{ title: "图片文件,语音文件", extensions: "jpg,gif,png,bmp,wav" }
				]
			},
			max_retries: 3,
			dragdrop: true,
			chunk_size: '2mb',
			auto_start: true, 
			init: {
				'FilesAdded': (up, files) ->
					console.log("FilesAdded")
					plupload.each(files, (file) ->
						console.log file
					);
				,
				'BeforeUpload': (up, file) ->
					console.log("BeforeUpload")
					file.name = "#{Meteor.userId()}#{(new Date()).getTime()}#{file.name}"
				,
				'UploadProgress': (up, file) ->
					console.log("UploadProgress")

					chunk_size = plupload.parseSize(this.getOption('chunk_size'));

					console.log(file.percent + "%", file.speed, chunk_size);
				,
				'FileUploaded': (up, file, info) ->
					console.log("FileUploaded")
					domain = up.getOption('domain');
					res = $.parseJSON(info);
					sourceLink = domain + res.key;
					console.log(sourceLink)
					fileUrl = sourceLink
					console.log(file)
					attachment = {
						title: "File Uploaded: #{file.name}",
						title_link: sourceLink,
						title_link_download: true
					};
					if /^image\/.+/.test(file.type) 
						attachment.image_url = fileUrl;
						attachment.image_type = file.type;
						attachment.image_size = file.size;
						if file.identify && file.identify.size
							attachment.image_dimensions = file.identify.size;
						
					else if /^audio\/.+/.test(file.type)
						attachment.audio_url = fileUrl;
						attachment.audio_type = file.type;
						attachment.audio_size = file.size;
					else if /^video\/.+/.test(file.type)
						attachment.video_url = fileUrl;
						attachment.video_type = file.type;
						attachment.video_size = file.size;
					

					msg = {
						_id: Random.id(),
						rid: instance.data._id,
						msg: '',
						file: {
							_id: file._id
						},
						groupable: false,
						attachments: [attachment]
					};
					console.log msg
					Meteor.call('sendMessage', msg, (err, result) ->
						console.log err
						console.log result
					);
				'Key': (up, file) ->
					if file.name.lastIndexOf('.') >= 0
						extname = file.name.slice(file.name.lastIndexOf('.') - file.name.length)
					else
						extname = '';

					if extname == '' && file.type.indexOf('/') >= 0
						extname = '.' + file.type.split('/')[1];
					
					now = new Date()
					key = "roomIMG-" + Meteor.userId() + "-" + now.getTime() + extname
				,
				'Error': (up, err, errTip) ->
					toastr.error(t(err.message))
				,
				'UploadComplete': (up, files) ->
					console.log("UploadComplete")
				
			}
		});

		instance.handler.set(uploadHandler)


Template.messageBox.onCreated ->
	@handler = new ReactiveVar {}
	@isMessageFieldEmpty = new ReactiveVar true
	@showMicButton = new ReactiveVar false

	@autorun =>
		wavRegex = /audio\/wav|audio\/\*/i
		wavEnabled = !CaoLiao.settings.get("FileUpload_MediaTypeWhiteList") || CaoLiao.settings.get("FileUpload_MediaTypeWhiteList").match(wavRegex)
		if CaoLiao.settings.get('Message_AudioRecorderEnabled') and (navigator.getUserMedia? or navigator.webkitGetUserMedia?) and wavEnabled and CaoLiao.settings.get('FileUpload_Enabled')
			@showMicButton.set true
		else
			@showMicButton.set false