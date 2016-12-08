
socialSharing = (options = {}) ->
	window.plugins.socialsharing.share(options.message, options.subject, options.file, options.link)

isSubscribed = (_id) ->
	return ChatSubscription.find({ rid: _id }).count() > 0

favoritesEnabled = ->
	return CaoLiao.settings.get 'Favorite_Rooms'

Template.room.helpers
	hasShow: ->
		return true
	vidoShow: ->
		return Session.get('videoShow') || false
	hasAction: (obj) ->
		return obj.action?
	favorite: ->
		sub = ChatSubscription.findOne { rid: this._id }, { fields: { f: 1 } }
		return 'icon-star favorite-room' if sub?.f? and sub.f and favoritesEnabled
		return 'icon-star-empty'

	favoriteLabel: ->
		sub = ChatSubscription.findOne { rid: this._id }, { fields: { f: 1 } }
		return "Unfavorite" if sub?.f? and sub.f and favoritesEnabled
		return "Favorite"

	subscribed: ->
		return isSubscribed(this._id)

	messagesHistory: ->
		return ChatMessage.find { rid: this._id, t: { '$ne': 't' }  }, { sort: { ts: 1 } }

	hasMore: ->
		return RoomHistoryManager.hasMore this._id

	hasMoreNext: ->
		return RoomHistoryManager.hasMoreNext this._id

	isLoading: ->
		return RoomHistoryManager.isLoading this._id

	windowId: ->
		return "chat-window-#{this._id}"

	uploading: ->
		return Session.get 'uploading'

	roomName: ->
		roomData = Session.get('roomData' + this._id)
		return '' unless roomData

		return CaoLiao.roomTypes.getRoomName roomData?.t, roomData

	did: ->
		return CaoLiao.models.Rooms.findOne(this._id)?.did

	roomTopic: ->
		roomData = Session.get('roomData' + this._id)
		return '' unless roomData
		return s.escapeHTML roomData.topic

	roomIcon: ->
		roomData = Session.get('roomData' + this._id)
		return '' unless roomData?.t

		return CaoLiao.roomTypes.getIcon roomData?.t

	userStatus: ->
		roomData = Session.get('roomData' + this._id)

		return {} unless roomData

		if roomData.t is 'd'
			username = _.without roomData.usernames, Meteor.user().username
			return Session.get('user_' + username + '_status') || 'offline'

		else
			return 'offline'

	flexOpened: ->
		return 'opened' if CaoLiao.TabBar.isFlexOpen()

	maxMessageLength: ->
		return CaoLiao.settings.get('Message_MaxAllowedSize')

	unreadData: ->
		data =
			count: RoomHistoryManager.getRoom(this._id).unreadNotLoaded.get() + Template.instance().unreadCount.get()

		room = RoomManager.getOpenedRoomByRid this._id
		if room?
			data.since = room.unreadSince?.get()

		return data

	formatUnreadSince: ->
		if not this.since? then return

		return moment(this.since).calendar(null, {sameDay: 'LT'})

	flexTemplate: ->
		return CaoLiao.TabBar.getTemplate()

	adminClass: ->
		return 'admin' if CaoLiao.authz.hasRole(Meteor.userId(), 'admin')

	showToggleFavorite: ->
		return true if isSubscribed(this._id) and favoritesEnabled()

	compactView: ->
		return 'compact' if Meteor.user()?.settings?.preferences?.compactView

	selectable: ->
		return Template.instance().selectable.get()

	buttons: ->
		visibleGroup = CaoLiao.TabBar.getVisibleGroup()
		showbuttons = []
		CaoLiao.OptionTabBar.getButtons().forEach (button) ->
			if button.groups.indexOf(visibleGroup) isnt -1
				showbuttons.push button
		return showbuttons#CaoLiao.HeaderOptsAction

	route: ->
		return CaoLiao.OptionTabBar.getRouteLink @id, {rid: Template.instance().data._id} 

	title: ->
		return t(@i18nTitle)

	waitJoinedRoon: ->
		if !isSubscribed(this._id) && !! ChatRoom.findOne { _id: @_id, t: 'c' }
			return true
		else
			return false

	mobileShowWebrtc: ->
		return Session.get("mobile-show-webrtc")

isSocialSharingOpen = false
touchMoved = false

Template.room.events
	"click .dropdownItem": (e, t)->
		$("#navigation-dropdown").hide()

	"click #join-video": (e, t) ->
		if CaoLiao.models.Debate.findOne(ChatRoom.findOne(t.data._id).did).webrtcJoined.length > 0 && Session.get('remoteCallData')?
			datatemp = Session.get("remoteCallData")
			if Session.get("remoteCallData")?
				if ChatRoom.findOne(Session.get('openedRoom')).left.length > ChatRoom.findOne(Session.get('openedRoom')).right.length
					direction = "right"
				else
					direction = "left"
				Session.set("joinedWebrtcDirection", direction)

				WebRTC.getInstanceByRoomId(Session.get('openedRoom')).joinCall({audio: true, video: true})

				delete RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).dom
						
				mainNode = document.querySelector('.main-content')
				if mainNode?
					for child in mainNode.children
						mainNode.removeChild child if child?
				
				roomDom = RoomManager.getDomOfRoom(RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).typeName, Session.get('openedRoom'))
				mainNode.appendChild roomDom

				
	"click .view-video": (e, t) ->
		if CaoLiao.models.Debate.findOne(ChatRoom.findOne(t.data._id).did).webrtcJoined.length > 0 && Session.get('remoteCallData')?
			datatemp = Session.get("remoteCallData")
			if Session.get("remoteCallData")?
				WebRTC.getInstanceByRoomId(Session.get('openedRoom')).joinCallOnlyView
					to: datatemp.from
					monitor: datatemp.monitor
					media: datatemp.media

				delete RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).dom
				
				mainNode = document.querySelector('.main-content')
				if mainNode?
					for child in mainNode.children
						mainNode.removeChild child if child?
				
				roomDom = RoomManager.getDomOfRoom(RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).typeName, Session.get('openedRoom'))
				mainNode.appendChild roomDom

	"click #open-video": (e, t) ->
		if CaoLiao.models.Debate.findOne(ChatRoom.findOne(t.data._id).did).webrtcJoined.length == 0 || !Session.get('remoteCallData')
			Session.set("joinedWebrtcDirection", "left")
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).startCall({audio: true, video: true})
			
			delete RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).dom
			
			mainNode = document.querySelector('.main-content')
			if mainNode?
				for child in mainNode.children
					mainNode.removeChild child if child?
			
			roomDom = RoomManager.getDomOfRoom(RoomManager.getOpenedRoomByRid(Session.get('openedRoom')).typeName, Session.get('openedRoom'))
			mainNode.appendChild roomDom

		#ChatRoom.findOne(t.data._id).left.push Meteor.userId()
		###
		loadviedo = Meteor.setInterval ->
			dif = 60 + $(".messages-container").find("footer").outerHeight() + $(".webrtc-video").height()
			$(".messages-box").css("height", "calc(100% - #{dif}px)")
			$(".messages-box").css("margin-top", ($(".webrtc-video").height() + 61) + "px")
		, 100	
		###
	"click #view-subject": (e, t) ->
		FlowRouter.go 'debate', { slug: ChatRoom.findOne(Session.get('openedRoom')).did}
		
	"click .header-search": ->
		FlowRouter.go 'search', { type: 'message' }
		
	"click, touchend": (e, t) ->
		Meteor.setTimeout ->
			t.sendToBottomIfNecessaryDebounced()
		, 100

	"touchstart .message": (e, t) ->
		touchMoved = false
		isSocialSharingOpen = false
		if e.originalEvent.touches.length isnt 1
			return

		if $(e.currentTarget).hasClass('system')
			return

		if e.target and e.target.nodeName is 'AUDIO'
			return

		if e.target and e.target.nodeName is 'A' and /^https?:\/\/.+/.test(e.target.getAttribute('href'))
			e.preventDefault()
			e.stopPropagation()

		message = this._arguments[1]
		doLongTouch = =>

			if window.plugins?.socialsharing?
				isSocialSharingOpen = true

				if e.target and e.target.nodeName is 'A' and /^https?:\/\/.+/.test(e.target.getAttribute('href'))
					if message.attachments?
						attachment = _.find message.attachments, (item) -> return item.title is e.target.innerText
						if attachment?
							socialSharing
								file: e.target.href
								subject: e.target.innerText
								message: message.msg
							return

					socialSharing
						link: e.target.href
						subject: e.target.innerText
						message: message.msg
					return

				if e.target and e.target.nodeName is 'IMG'
					socialSharing
						file: e.target.src
						message: message.msg
					return

			mobileMessageMenu.show(message, t, e, this)

		Meteor.clearTimeout t.touchtime
		t.touchtime = Meteor.setTimeout doLongTouch, 500

	"click .message img": (e, t) ->
		Meteor.clearTimeout t.touchtime
		if isSocialSharingOpen is true or touchMoved is true
			e.preventDefault()
			e.stopPropagation()

	"touchend .message": (e, t) ->
		Meteor.clearTimeout t.touchtime
		if isSocialSharingOpen is true
			e.preventDefault()
			e.stopPropagation()
			return

		if e.target and e.target.nodeName is 'A' and /^https?:\/\/.+/.test(e.target.getAttribute('href'))
			if touchMoved is true
				e.preventDefault()
				e.stopPropagation()
				return

			if cordova?.InAppBrowser?
				cordova.InAppBrowser.open(e.target.href, '_system')
			else
				window.open(e.target.href)

	"touchmove .message": (e, t) ->
		touchMoved = true
		Meteor.clearTimeout t.touchtime

	"touchcancel .message": (e, t) ->
		Meteor.clearTimeout t.touchtime

	"click .upload-progress-text > button": (e) ->
		e.preventDefault();
		Session.set "uploading-cancel-#{this.id}", true

	"click .unread-bar > button.mark-read": ->
		readMessage.readNow(true)

	"click .unread-bar > button.jump-to": (e, t) ->
		_id = t.data._id
		message = RoomHistoryManager.getRoom(_id)?.firstUnread.get()
		if message?
			RoomHistoryManager.getSurroundingMessages(message, 50)
		else
			subscription = ChatSubscription.findOne({ rid: _id })
			message = ChatMessage.find({ rid: _id, ts: { $gt: subscription?.ls } }, { sort: { ts: 1 }, limit: 1 }).fetch()[0]
			RoomHistoryManager.getSurroundingMessages(message, 50)

	"click .flex-tab .more": (event, t) ->
		if CaoLiao.TabBar.isFlexOpen()
			Session.set('rtcLayoutmode', 0)
			CaoLiao.TabBar.closeFlex()
			t.searchResult.set undefined
		else
			CaoLiao.TabBar.openFlex()

	'click .toggle-favorite': (event) ->
		event.stopPropagation()
		event.preventDefault()
		Meteor.call 'toggleFavorite', @_id, !$('i', event.currentTarget).hasClass('favorite-room'), (err) ->
			if err
				return handleError(err)

	'click .edit-room-title': (event) ->
		event.preventDefault()
		Session.set('editRoomTitle', true)
		$(".fixed-title").addClass "visible"
		Meteor.setTimeout ->
			$('#room-title-field').focus().select()
		, 10

	'scroll .wrapper': _.throttle (e, instance) ->
		if RoomHistoryManager.isLoading(@_id) is false and (RoomHistoryManager.hasMore(@_id) is true or RoomHistoryManager.hasMoreNext(@_id) is true)
			if RoomHistoryManager.hasMore(@_id) is true and e.target.scrollTop is 0
				RoomHistoryManager.getMore(@_id)
			else if RoomHistoryManager.hasMoreNext(@_id) is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				RoomHistoryManager.getMoreNext(@_id)
	, 200

	'click .load-more > button': ->
		RoomHistoryManager.getMore(@_id)

	'click .new-message': (e) ->
		Template.instance().atBottom = true
		Template.instance().find('.input-message').focus()

	'click .message-cog': (e) ->
		message = @_arguments[1]
		$('.message-dropdown:visible').hide()

		dropDown = $(".messages-box \##{message._id} .message-dropdown")

		if dropDown.length is 0
			actions = CaoLiao.MessageAction.getButtons message, 'message'

			el = Blaze.toHTMLWithData Template.messageDropdown,
				actions: actions

			$(".messages-box \##{message._id} .message-cog-container").append el

			dropDown = $(".messages-box \##{message._id} .message-dropdown")

		dropDown.show()

	'click .header-more-opts': (e) ->
		CaoLiao.OptionTabBar.toggle()

	'click .message-dropdown .message-action': (e, t) ->
		el = $(e.currentTarget)

		button = CaoLiao.MessageAction.getButtonById el.data('id')
		if button?.action?
			button.action.call @, e, t

	'click .message-dropdown-close': ->
		$('.message-dropdown:visible').hide()


	'click .image-to-download': (event) ->
		ChatMessage.update {_id: this._arguments[1]._id, 'urls.url': $(event.currentTarget).data('url')}, {$set: {'urls.$.downloadImages': true}}
		ChatMessage.update {_id: this._arguments[1]._id, 'attachments.image_url': $(event.currentTarget).data('url')}, {$set: {'attachments.$.downloadImages': true}}

	'click .collapse-switch': (e) ->
		index = $(e.currentTarget).data('index')
		collapsed = $(e.currentTarget).data('collapsed')
		id = @_arguments[1]._id

		if @_arguments[1]?.attachments?
			ChatMessage.update {_id: id}, {$set: {"attachments.#{index}.collapsed": !collapsed}}

		if @_arguments[1]?.urls?
			ChatMessage.update {_id: id}, {$set: {"urls.#{index}.collapsed": !collapsed}}

	'dragenter .dropzone': (e) ->
		e.currentTarget.classList.add 'over'

	'dragleave .dropzone-overlay': (e) ->
		e.currentTarget.parentNode.classList.remove 'over'

	'dragover .dropzone-overlay': (e) ->
		e = e.originalEvent or e
		if e.dataTransfer.effectAllowed in ['move', 'linkMove']
			e.dataTransfer.dropEffect = 'move'
		else
			e.dataTransfer.dropEffect = 'copy'

	'dropped .dropzone-overlay': (event) ->
		event.currentTarget.parentNode.classList.remove 'over'

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

	'load img': (e, template) ->
		template.sendToBottomIfNecessary?()

	'click .jump-recent button': (e, template) ->
		e.preventDefault()
		template.atBottom = true
		RoomHistoryManager.clear(template?.data?._id)

	'click .message': (e, template) ->
		if template.selectable.get()
			document.selection?.empty() or window.getSelection?().removeAllRanges()
			data = Blaze.getData(e.currentTarget)
			_id = data?._arguments?[1]?._id

			if !template.selectablePointer
				template.selectablePointer = _id

			if !e.shiftKey
				template.selectedMessages = template.getSelectedMessages()
				template.selectedRange = []
				template.selectablePointer = _id

			template.selectMessages _id

			selectedMessages = $('.messages-box .message.selected').map((i, message) -> message.id)
			removeClass = _.difference selectedMessages, template.getSelectedMessages()
			addClass = _.difference template.getSelectedMessages(), selectedMessages
			for message in removeClass
				$(".messages-box ##{message}").removeClass('selected')
			for message in addClass
				$(".messages-box ##{message}").addClass('selected')

Template.room.onCreated ->
	console.log "room.onCreated ",RoomHistoryManager.getMoreIfIsEmpty @data._id
	RoomHistoryManager.getMoreIfIsEmpty @data._id
	# this.scrollOnBottom = true
	# this.typing = new msgTyping this.data._id
	this.showUsersOffline = new ReactiveVar false
	this.atBottom = if FlowRouter.getQueryParam('msg') then false else true
	this.unreadCount = new ReactiveVar 0

	this.selectable = new ReactiveVar false
	this.selectedMessages = []
	this.selectedRange = []
	this.selectablePointer = null

	this.userDetail = new ReactiveVar FlowRouter.getParam('username')

	this.resetSelection = (enabled) =>
		this.selectable.set(enabled)
		$('.messages-box .message.selected').removeClass 'selected'
		this.selectedMessages = []
		this.selectedRange = []
		this.selectablePointer = null

	this.selectMessages = (to) =>
		if this.selectablePointer is to and this.selectedRange.length > 0
			this.selectedRange = []
		else
			message1 = ChatMessage.findOne this.selectablePointer
			message2 = ChatMessage.findOne to

			minTs = _.min([message1.ts, message2.ts])
			maxTs = _.max([message1.ts, message2.ts])

			this.selectedRange = _.pluck(ChatMessage.find({ rid: message1.rid, ts: { $gte: minTs, $lte: maxTs } }).fetch(), '_id')

	this.getSelectedMessages = =>
		messages = this.selectedMessages
		addMessages = false
		for message in this.selectedRange
			if messages.indexOf(message) is -1
				addMessages = true
				break

		if addMessages
			previewMessages = _.compact(_.uniq(this.selectedMessages.concat(this.selectedRange)))
		else
			previewMessages = _.compact(_.difference(this.selectedMessages, this.selectedRange))

		return previewMessages

	this.setUserDetail = (username) =>
		this.userDetail.set username

	this.clearUserDetail = =>
		this.userDetail.set null

	Meteor.call 'getRoomRoles', @data._id, (error, results) ->
		if error
			return handleError(error)

		for record in results
			delete record._id
			RoomRoles.upsert { rid: record.rid, "u._id": record.u._id }, record

	RoomRoles.find({ rid: @data._id }).observe
		added: (role) =>
			ChatMessage.update { rid: @data._id, "u._id": role?.u?._id }, { $addToSet: { roles: role._id } }, { multi: true } # Update message to re-render DOM
		changed: (role, oldRole) =>
			ChatMessage.update { rid: @data._id, "u._id": role?.u?._id }, { $inc: { rerender: 1 } }, { multi: true } # Update message to re-render DOM
		removed: (role) =>
			ChatMessage.update { rid: @data._id, "u._id": role?.u?._id }, { $pull: { roles: role._id } }, { multi: true } # Update message to re-render DOM

	dorpdownInterval = Meteor.setInterval(->
		if $(".dropdown-button")?
			$(".dropdown-button").dropdown()
			Meteor.clearInterval(dorpdownInterval)
	, 100)
	


Template.room.onRendered ->
	debateSubscription = Meteor.subscribe('debate', ChatRoom.findOne(Session.get('openedRoom'))?.did)

	###
	refreshinterval = Meteor.setInterval ->
		if document.getElementById("roomContainer").querySelector(".messages-box")?
			refresher.init
				id:"roomContainer",
				insertBeforeElem: ".messages-box",
				pullUpAction:Load,
				pullDownLable: "pullDownLable",
				pullingDownLable: "pullingDownLable",
				pullUpLable: "pullUpLable",
				pullingUpLable: "pullingUpLable",
				loadingLable: "loadingLable..."
			Meteor.clearInterval(refreshinterval)
	, 100
	

	Load = -> 
		window.open("http://www.163.com");
	###
	CaoLiao.OptionTabBar.closeTabBar()
	unless window.chatMessages
		window.chatMessages = {}
	unless window.chatMessages[Session.get('openedRoom')]
		window.chatMessages[Session.get('openedRoom')] = new ChatMessages
	chatMessages[Session.get('openedRoom')].init(this.firstNode)
	# ScrollListener.init()

	wrapper = this.find('.wrapper')
	wrapperUl = this.find('.wrapper > ul')
	newMessage = this.find(".new-message")

	template = this

	containerBars = $('.messages-container > .container-bars')
	containerBarsOffset = containerBars.offset()

	template.isAtBottom = ->
		if wrapper.scrollTop >= wrapper.scrollHeight - wrapper.clientHeight
			newMessage.className = "new-message not"
			return true
		return false

	template.sendToBottom = ->
		wrapper.scrollTop = wrapper.scrollHeight - wrapper.clientHeight
		newMessage.className = "new-message not"

	template.checkIfScrollIsAtBottom = ->
		template.atBottom = template.isAtBottom()
		readMessage.enable()
		readMessage.read()

	template.sendToBottomIfNecessary = ->
		if template.atBottom is true and template.isAtBottom() isnt true
			template.sendToBottom()

	template.sendToBottomIfNecessaryDebounced = _.debounce template.sendToBottomIfNecessary, 10

	template.sendToBottomIfNecessary()

	if not window.MutationObserver?
		wrapperUl.addEventListener 'DOMSubtreeModified', ->
			template.sendToBottomIfNecessaryDebounced()
	else
		observer = new MutationObserver (mutations) ->
			mutations.forEach (mutation) ->
				template.sendToBottomIfNecessaryDebounced()

		observer.observe wrapperUl,
			childList: true
		# observer.disconnect()

	template.onWindowResize = ->
		Meteor.defer ->
			template.sendToBottomIfNecessaryDebounced()

	window.addEventListener 'resize', template.onWindowResize

	wrapper.addEventListener 'mousewheel', ->
		template.atBottom = false
		Meteor.defer ->
			template.checkIfScrollIsAtBottom()

	wrapper.addEventListener 'wheel', ->
		template.atBottom = false
		Meteor.defer ->
			template.checkIfScrollIsAtBottom()

	wrapper.addEventListener 'touchstart', ->
		template.atBottom = false

	wrapper.addEventListener 'touchend', ->
		Meteor.defer ->
			template.checkIfScrollIsAtBottom()
		Meteor.setTimeout ->
			template.checkIfScrollIsAtBottom()
		, 1000
		Meteor.setTimeout ->
			template.checkIfScrollIsAtBottom()
		, 2000

	$('.flex-tab-bar').on 'click', (e, t) ->
		Meteor.setTimeout ->
			template.sendToBottomIfNecessaryDebounced()
		, 100

	updateUnreadCount = _.throttle ->
	
		firstMessageOnScreen = document.elementFromPoint(containerBarsOffset.left+1, containerBarsOffset.top+containerBars.height()+1)
		if firstMessageOnScreen?.id?
			firstMessage = ChatMessage.findOne firstMessageOnScreen.id
			if firstMessage?
				subscription = ChatSubscription.findOne rid: template.data._id
				count = ChatMessage.find({rid: template.data._id, ts: {$lt: firstMessage.ts, $gt: subscription?.ls}}).count()
				template.unreadCount.set count
			else
				template.unreadCount.set 0
	, 300

	readMessage.onRead (rid) ->
		if rid is template.data._id
			template.unreadCount.set 0

	wrapper.addEventListener 'scroll', ->
		updateUnreadCount()

	# salva a data da renderização para exibir alertas de novas mensagens
	$.data(this.firstNode, 'renderedAt', new Date)

	webrtc = WebRTC.getInstanceByRoomId template.data._id
	
	if webrtc?
		Tracker.autorun ->

			if debateSubscription.ready()

				if ChatRoom.findOne(template.data._id)?.did?
					if CaoLiao.models.Debate.findOne(ChatRoom.findOne(template.data._id).did).webrtcJoined.length > 0 && Session.get('remoteCallData')
						$("#open-video").parent().hide()
						$(".view-video").show()
						$("#join-video").parent().show()


					else
						$("#open-video").parent().show()
						$(".view-video").hide()
						$("#join-video").parent().hide()


				else
					$("#open-video").show()
					$(".view-video").hide()

				if webrtc.remoteItems.get()?.length > 0
					CaoLiao.TabBar.setTemplate 'membersList'
					CaoLiao.TabBar.openFlex()

				if webrtc.localUrl.get()?
					CaoLiao.TabBar.setTemplate 'membersList'
					CaoLiao.TabBar.openFlex()

Template.room.onDestroyed ->
	console.log "onDestroyed stop-call"
	WebRTC.getInstanceByRoomId(Session.get('openedRoom'))?.stop()