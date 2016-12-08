Template.videoCall.onCreated ->
	@mainVideo = new ReactiveVar '$auto'
	@leftLocked = new ReactiveVar false
	@rightLocked = new ReactiveVar false

Template.videoCall.onRendered ->
	self = this

	swiper = new Swiper('.swiper-item-container', {
		slidesPerView: 3,
		paginationClickable: true,
		spaceBetween: 30
	});

	Tracker.autorun ->
		if WebRTC?.getInstanceByRoomId(Session.get('openedRoom'))?.localUrl? && WebRTC.getInstanceByRoomId(Session.get('openedRoom')).localUrl.get()?
			self.mainVideo.set '$self'
		
Template.videoCall.onDestroyed ->
	console.log "videoCall.onDestroyed"

	if Session.get("mobile-show-webrtc") == false
		if RoomManager.getOpenedRoomByRid(Session.get('openedRoom'))?.dom?
			delete RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).dom

		mainNode = document.querySelector('.main-content')
		
		if mainNode?
			for child in mainNode.children
				mainNode.removeChild child if child?
		
		if RoomManager.getOpenedRoomByRid(Session.get('openedRoom'))?.typeName?
			roomDom = RoomManager.getDomOfRoom(RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).typeName, Session.get('openedRoom'))
			
			mainNode.appendChild roomDom


Template.videoCall.helpers
	notJoinedLeft: ->
		if ChatRoom.findOne({_id: Session.get('openedRoom'), "left._id": Meteor.userId()})?
			return false
		else
			return ChatRoom.findOne(Session.get('openedRoom')).left.length < Settings.findOne("Webrtc_Max_Len_Of_Left").value

	notJoinedRight: ->
		if ChatRoom.findOne({_id: Session.get('openedRoom'), "right._id": Meteor.userId()})?
			return false
		else
			return ChatRoom.findOne(Session.get('openedRoom')).right.length < Settings.findOne("Webrtc_Max_Len_Of_Right").value

	leftLocked: ->
		return Template.instance().leftLocked.get()
	rightLocked: ->
		return Template.instance().rightLocked.get()

	isCordova: ->
		return Meteor.isCordova
	videoCapture: ->
		return videoCapture
	debateVideo: ->
		return ChatRoom.findOne(Session.get('openedRoom')).dtype
	side: ->
		return "left"
	videoAvaliable: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom'))?

	videoActive: ->
		webrtc = WebRTC.getInstanceByRoomId(Session.get('openedRoom'))
		overlay = @overlay?
		if overlay isnt webrtc?.overlayEnabled.get()
			return false

		return webrtc.localUrl.get()? or webrtc.remoteItems.get()?.length > 0

	callInProgress: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).callInProgress.get()

	overlayEnabled: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).overlayEnabled.get()

	audioEnabled: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).audioEnabled.get()

	videoEnabled: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).videoEnabled.get()

	audioAndVideoEnabled: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).audioEnabled.get() and WebRTC.getInstanceByRoomId(Session.get('openedRoom')).videoEnabled.get()

	screenShareAvailable: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).screenShareAvailable

	screenShareEnabled: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).screenShareEnabled.get()

	remoteVideoItems: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).remoteItems.get()

	remoteVideoItemsLeft: ->
		return _.filter( WebRTC.getInstanceByRoomId(Session.get('openedRoom')).remoteItems.get(), (item) ->
			if ChatRoom.findOne({_id: Session.get('openedRoom'), "left._id": item.id})?
				return item
		)

	remoteVideoItemsRight: ->
		return _.filter( WebRTC.getInstanceByRoomId(Session.get('openedRoom')).remoteItems.get(), (item) ->
			if ChatRoom.findOne({_id: Session.get('openedRoom'), "right._id": item.id})?
				return item
		)

	selfVideoUrl: ->
		return WebRTC.getInstanceByRoomId(Session.get('openedRoom')).localUrl.get()

	mainVideoUrl: ->
		template = Template.instance()
		webrtc = WebRTC.getInstanceByRoomId(Session.get('openedRoom'))

		if template.mainVideo.get() is '$self'
			return webrtc.localUrl.get()

		if template.mainVideo.get() is '$auto'
			remoteItems = webrtc.remoteItems.get()
			if remoteItems?.length > 0
				return remoteItems[0].url

			return webrtc.localUrl.get()

		if webrtc.remoteItemsById.get()[template.mainVideo.get()]?
			return webrtc.remoteItemsById.get()[template.mainVideo.get()].url
		else
			template.mainVideo.set '$auto'
			return

	mainVideoUsername: ->
		template = Template.instance()
		webrtc = WebRTC.getInstanceByRoomId(Session.get('openedRoom'))

		if template.mainVideo.get() is '$self'
			return t 'you'

		if template.mainVideo.get() is '$auto'
			remoteItems = webrtc.remoteItems.get()
			if remoteItems?.length > 0
				return Meteor.users.findOne(remoteItems[0].id)?.username

			return t 'you'

		if webrtc.remoteItemsById.get()[template.mainVideo.get()]?
			return Meteor.users.findOne(webrtc.remoteItemsById.get()[template.mainVideo.get()].id)?.username
		else
			template.mainVideo.set '$auto'
			return

	usernameByUserId: (userId) ->
		return Meteor.users.findOne(userId)?.username


Template.videoCall.events
	'click .join-left': (e, t)->
		if CaoLiao.models.Debate.findOne(ChatRoom.findOne(t.data._id).did).webrtcJoined.length > 0 && Session.get('remoteCallData')?
			datatemp = Session.get("remoteCallData")
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).stop()
			Session.set("joinedWebrtcDirection", "left")
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).joinCall({audio: true, video: true})
		else
			console.log "No_Remote_User"
			toastr.error TAPi18n.__("No_Remote_User")

	'click .join-right': (e, t)->
		if CaoLiao.models.Debate.findOne(ChatRoom.findOne(t.data._id).did).webrtcJoined.length > 0 && Session.get('remoteCallData')?
			datatemp = Session.get("remoteCallData")
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).stop()
			Session.set("joinedWebrtcDirection", "right")
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).joinCall({audio: true, video: true})
		else
			console.log "No_Remote_User"
			toastr.error TAPi18n.__("No_Remote_User")


	'click .icon-lock-open': (e, t)->
		if $(e.currentTarget).data('direction') == "left"
			t.leftLocked.set(false)
			$(".videos.left .content").addClass("show")
			$(".videos.left .content").removeClass("hide")
		if $(e.currentTarget).data('direction') == "right"
			t.rightLocked.set(false)
			$(".videos.right .content").addClass("show")
			$(".videos.right .content").removeClass("hide")

	'click .icon-lock': (e, t)->
		if $(e.currentTarget).data('direction') == "left"
			t.leftLocked.set(true)
			$(".videos.left .content").addClass("hide")
			$(".videos.left .content").removeClass("show")
		if $(e.currentTarget).data('direction') == "right"
			t.rightLocked.set(true)
			$(".videos.right .content").addClass("hide")
			$(".videos.right .content").removeClass("show")

	'click .stop-call': ->

		document.querySelector('.webrtc-video').remove()

		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).stop()
			
		#delete RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).dom
		
		#if videoNode?
		#	for child in videoNode.children
		#		videoNode.removeChild child if child?
		
		#roomDom = RoomManager.getDomOfRoom(RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).typeName, Session.get('openedRoom'))
		#mainNode.appendChild roomDom

	'click .video-item': (e, t) ->
		t.mainVideo.set $(e.currentTarget).data('username')

	'click .disable-audio': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).disableAudio()

	'click .enable-audio': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).enableAudio()

	'click .disable-video': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).disableVideo()

	'click .enable-video': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).enableVideo()

	'click .disable-screen-share': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).disableScreenShare()

	'click .enable-screen-share': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).enableScreenShare()

	'click .disable-overlay': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).overlayEnabled.set(false)

	'click .enable-overlay': (e, t) ->
		WebRTC.getInstanceByRoomId(Session.get('openedRoom')).overlayEnabled.set(true)

	'loadstart video[muted]': (e) ->
		e.currentTarget.muted = true
		e.currentTarget.volume = 0
