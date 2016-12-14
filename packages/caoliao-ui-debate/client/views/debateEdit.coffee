isSubscribed =  ->
	return FlowRouter.subsReady('debate')

Template.debateEdit.helpers
	isSubscribed: ->
		return isSubscribed()
	pagetitle: ->
		return CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.name or TAPi18n.__("Debate_Create")
	invalidEdit: ->
		return @invalidEdit
	name: ->
		name = CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.name
		Template.instance().name.set(name);
		return name
	flexOpened: ->
		return 'opened' if CaoLiao.TabBar.isFlexOpen()
	arrowPosition: ->
		return 'left' unless CaoLiao.TabBar.isFlexOpen()
	mobile: ->
		md = new MobileDetect(window.navigator.userAgent);
		return Meteor.isCordova || md.mobile()?


Template.debateEdit.onRendered ->
	###
	Meteor.call("getDebate", FlowRouter.current().params.slug, (error, result)->
		if error?
			toastr.error TAPi18n.__(error.message)
		else 
			CaoLiao.models.Debate.upsert {_id: FlowRouter.current().params.slug}, result
	);
	###
	self = @
	Tracker.autorun ->

		if $(".wangEditor-mobile-txt").length > 0
			self?.hasEditor.set(true)
		if isSubscribed() && CaoLiao.models.Debate.find(FlowRouter.current().params.slug).count() == 0
			FlowRouter.go("/debates/");

		if isSubscribed() && CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)? && self?.hasEditor.get() is false
			width = $(window).width()
			console.log CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)
			if CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).save
				Session.set("debateType", CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug).debateType)
			self.invalidEdit.set(Meteor.userId() != CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.u._id)


			md = new MobileDetect(window.navigator.userAgent);

			if Meteor.isCordova || md.mobile()?
				editorobj = new window.___E('edit-content');
				editorobj.config.menus = [
					'head',
					'bold',
					'color',
					'quote',
					'list',
					'img',
					'check'
				]
				editorobj.config.loadingImg = '/images/logo/loading.gif';
				editorobj.config.uploadImgUrl = '/uploadDebateImg';
				editorobj.config.uploadTimeout = 20 * 1000;
				editorobj.init();
				#console.log "wang init",CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody
				editorobj.$txt.html(CaoLiao.utils.extendImgSrcs(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody || "", "?imageMogr2/thumbnail/#{width}/quality/100"))
				self.editor.set(editorobj)
				self.hasEditor.set(true)
			else
				editorobj = new wangEditor('edit-content');
				editorobj.config.customUpload = true;
				editorobj.config.customUploadInit =->
					editor = this;
					btnId = editor.customUploadBtnId;
					containerId = editor.customUploadContainerId;
					uploader = Qiniu.uploader(
						runtimes: 'html5,flash,html4',
						browse_button: btnId,
						uptoken_url: '/api/uptoken',
						domain: 'http://o8rnbrutf.bkt.clouddn.com/',
						container: containerId,
						max_file_size: '100mb',
						flash_swf_url: '../js/plupload/Moxie.swf',
						filters: {
							mime_types: [
								{ title: "图片文件", extensions: "jpg,gif,png,bmp" }
							]
						},
						max_retries: 3,
						dragdrop: true,
						drop_element: 'editor-container',
						chunk_size: '4mb',
						auto_start: true, 
						init: 
							'FilesAdded': (up, files) ->
								plupload.each(files, (file) ->
								);
							,
							'BeforeUpload': (up, file) ->
								file.name = "#{Meteor.userId()}#{(new Date()).getTime()}#{file.name}"
							,
							'UploadProgress': (up, file) ->
								editor.showUploadProgress(file.percent);
							,
							'FileUploaded': (up, file, info) ->
								domain = up.getOption('domain');
								res = $.parseJSON(info);
								sourceLink = domain + res.key + "?imageMogr2/thumbnail/#{width}/quality/100";
								editor.command(null, 'insertHtml', '<img src="' + sourceLink + '" style="max-width:100%;"/>')
							,
							'Error': (up, err, errTip) ->
								toastr.error TAPi18n.__(err.message)
							,
							'UploadComplete': ->
								editor.hideUploadProgress();
							'Key': (up, file) ->
								if file.name.lastIndexOf('.') >= 0
									extname = file.name.slice(file.name.lastIndexOf('.') - file.name.length)
								else
									extname = '';

								if extname == '' && file.type.indexOf('/') >= 0
									extname = '.' + file.type.split('/')[1];
								
								now = new Date()
								key = "debateIMG-" + Meteor.userId() + "-" + now.getTime() + extname
					);
				editorobj.create();
				#console.log "create end",CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody
				editorobj.$txt.html(CaoLiao.utils.extendImgSrcs(CaoLiao.models.Debate.findOne(FlowRouter.current().params.slug)?.htmlBody || "", "?imageMogr2/thumbnail/#{width}/quality/100"))

				self.editor.set(editorobj)
				self.hasEditor.set(true)
				console.log "mobile editorobj"

		if Session.get("debateType")? && Session.get("debateType")!=undefined && $(".icon-ok-a").hasClass('load-circle')
			self.createDebate()
			
Template.debateEdit.onCreated ->
	@editor = new ReactiveVar null
	@name = new ReactiveVar ""
	@save = new ReactiveVar false
	@hasEditor = new ReactiveVar false
	@invalidEdit = new ReactiveVar true


	#console.log "onCreated",@
	self = @


	@createDebate = () =>
		if self.editor?.get()?
			save = false
			if $(".icon-ok-a").hasClass('load-circle') && Session.get("debateType")? && Session.get("debateType")!=undefined
				save = true
				self.save.set(true)
			imgs = [];
			document.getElementById("edit-content").querySelectorAll('img').forEach((element) ->
				if element.offsetWidth > 200 && element.offsetHeight > 150
					imgs.push(element.src)
			)

			temp = {
				_id: FlowRouter.current().params.slug
				name: self.name.get()
				content: localStorage.getItem("debateContent")
				debateType: Session.get("debateType")
				members: []
				save: save
				imgs: imgs
			}

			if save == true
				console.log "save"
				opts = {
					lines: 13, 
					length: 11,
					width: 5, 
					radius: 17,
					corners: 1,
					rotate: 0, 
					color: '#FFF',
					speed: 1, 
					trail: 60, 
					shadow: false,
					hwaccel: false, 
					className: 'spinner',
					zIndex: 2e9,
					top: 'auto',
					left: 'auto'
				};
				target = document.createElement("div");
				document.body.appendChild(target);
				spinner = new Spinner(opts).spin(target);
				overlay = window.iosOverlay({
					text: "Loading",
					spinner: spinner
				});

			Meteor.call("createDebate", temp, (error, result)->
				Session.set("debateType", null)
				overlay?.hide()
				if error?
					handleError(error)
					###
					if error.error is 'error-invalid-name-length'
						toastr.error TAPi18n.__("error-invalid-name-length", {
							name: temp.name,
							min_length: Settings.findOne("UTF8_Names_MinLength").value, 
							max_length: Settings.findOne("UTF8_Names_MaxLength").value
						})
					else if error.error is 'error-duplicate-channel-name'
						toastr.error TAPi18n.__("error-duplicate-channel-name", {
							channel_name: temp.name
						})
					else if error.error is 'error-duplicate-debate-name'
						toastr.error TAPi18n.__("error-duplicate-debate-name", {
							debate_name: temp.name
						})
					else if error.error is 'error-empty-debate-name'
						toastr.error TAPi18n.__("error-empty-debate-name", {
							name: temp.name
						})
					else if error.error is 'error-rule-not-allowed'
						toastr.error TAPi18n.__("error-create-debate-count-off")

					else if error.error is 'user-not-allow-for-the-debateType'
						toastr.error TAPi18n.__("error-not-allow-for-the-debateType")

					else
						toastr.error(error.message)
					###
					$(".icon-ok-a").removeClass('load-circle');
				else
					if save
						$(".icon-ok-a").removeClass('load-circle');
						
						if result?
							FlowRouter.go("/debate/"+result);
						else
							toastr.error TAPi18n.__("__debate_not_exists__");
							FlowRouter.go("/openFlag/debates/News");
			)


	@intervalUpdate = Meteor.setInterval( ->
		self.createDebate()
	, 10000)


Template.debateEdit.events
	'click .icon-ok-a': (event, instance)->
		$(".icon-ok-a").addClass('load-circle');
		if !Session.get("debateType")? || Session.get("debateType")==undefined
			$("#debateType").openModal()
		else
			instance.createDebate()
	'keyup .debate-name': (event, instance) ->
		instance.name.set(event.currentTarget.value);

	'keyup .edit-content': (event, instance) ->
		localStorage.setItem("debateContent", instance.editor.get().$txt.html())

Template.debateEdit.onDestroyed ->
	console.log "onDestroyed"
	instance = this
	Meteor.clearInterval(instance.intervalUpdate);
	if !instance.save.get()
		instance.createDebate()

