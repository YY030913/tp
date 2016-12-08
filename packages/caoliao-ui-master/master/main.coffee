Meteor.startup ->
	if Meteor.isCordova
		window.plugins.uniqueDeviceID.get(success, fail);

success = (uuid) ->
	console.log(uuid)
fail = (err) ->
	console.log(err)

Template.body.onRendered ->
	###
	alog 'set', 'alias', { tongji: 'tongji.js' }
	alog 'tongji.set', 'id', '117db99758bc30d29de3e7b52a5d4b92'

	alog 'pv.create', 
		postUrl: 'http:#localhost:3000/p.gif',
		title: document.title

	alog('pv.send', 'pageview');

	window.alogObjectName = "alog"
	window["alog"] = window["alog"] || (window["alog"].q = window["alog"].q || []).push(arguments)
	window["alog"].l = window["alog"].l || +new Date
	i = document.createElement("script")
	i.asyn = 1
	i.src = "../../alog.min.js"
	m = document.getElementsByTagName("script")[0]
	m.parentNode.insertBefore(i, m)
	
	
	objectName = window.alogObjectName || 'alog';

	alog = window[objectName] = window[objectName] || ->
		window[objectName].l = window[objectName].l || +new Date;
		(window[objectName].q = window[objectName].q || []).push(arguments);

	trackerName = 'speed';
	alog('define', trackerName, ->
		tracker = alog.tracker(trackerName);
		timestamp = alog.timestamp; # 获取时间戳的函数，相对于alog被声明的时间
		console.log(timestamp());
		tracker.on('record', (url, time) ->
			data = {};
			data[url] = timestamp(time);
			tracker.send('timing', data);
			console.log(data);
		);
		tracker.set('protocolParameter', {
			# 配置字段，不需要上报
			headend: null,
			bodyend: null,
			domready: null
		});
		tracker.create({
			postUrl: 'http://localhost:3000/'
		});
		tracker.send('pageview', {
			ht: timestamp(tracker.get('headend')),
			lt: timestamp(tracker.get('bodyend')),
			drt: timestamp(tracker.get('domready'))
		});
		return tracker;
	)
	###

	###
	$(".animsition").animsition({
		inClass : 'fade-in',
		outClass : 'fade-out',
		inDuration : 1500,
		outDuration : 800,
		linkElement : '.animsition-link',loading:	true,
		loadingParentElement : 'body',
		loadingClass : 'animsition-loading',
		unSupportCss : [ 'animation-duration',
			'-webkit-animation-duration',
			'-o-animation-duration'],
		overlay : false,
		overlayClass : 'animsition-overlay-slide',
		overlayParentElement : 'body'
	});
	###
	
	#clipboard = new Clipboard('.clipboard')

	$(document.body).on 'keydown', (e) ->
		if e.keyCode is 80 and (e.ctrlKey is true or e.metaKey is true) and e.shiftKey is false
			e.preventDefault()
			e.stopPropagation()
			spotlight.show()

		if e.keyCode is 27
			spotlight.hide()

		unread = Session.get('unread')
		if e.keyCode is 27 and e.shiftKey is true and unread? and unread isnt ''
			e.preventDefault()
			e.stopPropagation()
			swal
				title: t('Clear_all_unreads_question')
				type: 'warning'
				confirmButtonText: t('Yes_clear_all')
				showCancelButton: true
				cancelButtonText: t('Cancel')
				confirmButtonColor: '#DD6B55'
			, ->
				subscriptions = ChatSubscription.find({open: true}, { fields: { unread: 1, alert: 1, rid: 1, t: 1, name: 1, ls: 1 } })
				for subscription in subscriptions.fetch()
					if subscription.alert or subscription.unread > 0
						Meteor.call 'readMessages', subscription.rid

	###
	$(document.body).on 'click', 'a', (e) ->
		link = e.currentTarget
		if link.origin is s.rtrim(Meteor.absoluteUrl(), '/') and /msg=([a-zA-Z0-9]+)/.test(link.search)
			e.preventDefault()
			e.stopPropagation()
			FlowRouter.go(link.pathname + link.search)
	###

	Tracker.autorun (c) ->
		w = window
		d = document
		s = 'script'
		l = 'dataLayer'
		i = CaoLiao.settings.get 'GoogleTagManager_id'
		if Match.test(i, String) and i.trim() isnt ''
			c.stop()
			do (w,d,s,l,i) ->
				w[l] = w[l] || []
				w[l].push {'gtm.start': new Date().getTime(), event:'gtm.js'}
				f = d.getElementsByTagName(s)[0]
				j = d.createElement(s)
				dl = if l isnt 'dataLayer' then '&l=' + l else ''
				j.async = true
				j.src = '//www.googletagmanager.com/gtm.js?id=' + i + dl
				f.parentNode.insertBefore j, f

	Tracker.autorun (c) ->
		if CaoLiao.settings.get 'Meta_language'
			c.stop()

			Meta.set
				name: 'http-equiv'
				property: 'content-language'
				content: CaoLiao.settings.get 'Meta_language'
			Meta.set
				name: 'name'
				property: 'language'
				content: CaoLiao.settings.get 'Meta_language'

	Tracker.autorun (c) ->
		if CaoLiao.settings.get 'Meta_fb_app_id'
			c.stop()

			Meta.set
				name: 'property'
				property: 'fb:app_id'
				content: CaoLiao.settings.get 'Meta_fb_app_id'

	Tracker.autorun (c) ->
		if CaoLiao.settings.get 'Meta_robots'
			c.stop()

			Meta.set
				name: 'name'
				property: 'robots'
				content: CaoLiao.settings.get 'Meta_robots'

	Tracker.autorun (c) ->
		if CaoLiao.settings.get 'Meta_google-site-verification'
			c.stop()

			Meta.set
				name: 'name'
				property: 'google-site-verification'
				content: CaoLiao.settings.get 'Meta_google-site-verification'

	Tracker.autorun (c) ->
		if CaoLiao.settings.get 'Meta_msvalidate01'
			c.stop()

			Meta.set
				name: 'name'
				property: 'msvalidate.01'
				content: CaoLiao.settings.get 'Meta_msvalidate01'

	Tracker.autorun (c) ->
		c.stop()

		Meta.set
			name: 'name'
			property: 'application-name'
			content: CaoLiao.settings.get 'Site_Name'

		Meta.set
			name: 'name'
			property: 'apple-mobile-web-app-title'
			content: CaoLiao.settings.get 'Site_Name'

	if Meteor.isCordova
		$(document.body).addClass 'is-cordova'

Template.main.helpers

	isweb: ->
		return Meteor.isClient && !Meteor.isCordova
	siteName: ->
		return CaoLiao.settings.get 'Site_Name'

	logged: ->
		if Meteor.userId()?
			$('html').addClass("noscroll").removeClass("scroll")
			Meteor.call 'logged'
			return true
		else
			$('html').addClass("scroll").removeClass("noscroll")
			return false

	useIframe: ->
		return false
		#return CaoLiao.iframeLogin.reactiveEnabled.get()

	iframeUrl: ->
		return ''
		#return CaoLiao.iframeLogin.reactiveIframeUrl.get()

	subsReady: ->
		return not Meteor.userId()? or (FlowRouter.subsReady('userData', 'activeUsers', 'friendSubscriptionData'))

	subReady: (sub)->
		return FlowRouter.subsReady(sub);

	hasUsername: ->
		return Meteor.userId()? and Meteor.user().username?

	flexOpened: ->
		return 'flex-opened' if CaoLiao.TabBar.isFlexOpen()

	flexOpenedRTC1: ->
		return 'layout1' if Session.equals('rtcLayoutmode', 1)

	flexOpenedRTC2: ->
		return 'layout2' if (Session.get('rtcLayoutmode') > 1)

	requirePasswordChange: ->
		return Meteor.user()?.requirePasswordChange is true

	CustomScriptLoggedOut: ->
		CaoLiao.settings.get 'Custom_Script_Logged_Out'

	CustomScriptLoggedIn: ->
		CaoLiao.settings.get 'Custom_Script_Logged_In'


Template.main.events

	"click .burger": ->
		console.log 'room click .burger' if window.rocketDebug
		chatContainer = $("#rocket-chat")
		menu.toggle()

	'touchstart': (e, t) ->
		if document.body.clientWidth > 780
			return
		if e.currentTarget.className == "touch-slider"
			return
		t.touchstartX = undefined
		t.touchstartY = undefined
		t.movestarted = false
		t.blockmove = false
		if $(e.currentTarget).closest('.main-content').length > 0
			t.touchstartX = e.originalEvent.touches[0].clientX
			t.touchstartY = e.originalEvent.touches[0].clientY
			t.mainContent = $('.main-content')
			t.wrapper = $('.messages-box > .wrapper')

	'touchmove': (e, t) ->
		if t.touchstartX?
			
			touch = e.originalEvent.touches[0]
			
			if touch.className == "touch-slider"
				return

			diffX = t.touchstartX - touch.clientX
			diffY = t.touchstartY - touch.clientY
			absX = Math.abs(diffX)
			absY = Math.abs(diffY)

			if t.movestarted isnt true and t.blockmove isnt true and absY > 5
				t.blockmove = true

			if t.blockmove isnt true and (t.movestarted is true or absX > 5)
				t.movestarted = true

				if menu.isOpen()
					t.left = 260 - diffX
				else
					t.left = -diffX

				if t.left > 260
					t.left = 260
				if t.left < 0
					t.left = 0

				t.mainContent.addClass('notransition')
				t.mainContent.css('transform', 'translate('+t.left+'px)')
				t.wrapper.css('overflow', 'hidden')

	'touchend': (e, t) ->
		if t.movestarted is true
			t.mainContent.removeClass('notransition')
			t.mainContent.css('transform', '');
			t.wrapper.css('overflow', '')

			if menu.isOpen()
				if t.left >= 200
					menu.open()
				else
					menu.close()
			else
				if t.left >= 60
					menu.open()
				else
					menu.close()


Template.main.onRendered ->
	console.log "main.onRendered"
	# RTL Support - Need config option on the UI
	if isRtl localStorage.getItem "userLanguage"
		$('html').addClass "rtl"
	else
		$('html').removeClass "rtl"

	$('#initial-page-loading').remove()

	window.addEventListener 'focus', ->
		Meteor.setTimeout ->
			if not $(':focus').is('INPUT,TEXTAREA')
				$('.input-message').focus()
		, 100

	###
	$("#jscssloaded").find("script").remove()
	
	if Meteor.isCordova
		__root_url__ = cordova.file.applicationDirectory.replace('file://', '') + 'www/application/app';
	else
		__root_url__ = CaoLiao.settings.get("Site_Url");
	loadjscssfile("#{__root_url__}/js/materialize.min.js","js")
	loadjscssfile("#{__root_url__}/js/plugins/perfect-scrollbar/perfect-scrollbar.min.js","js")
	loadjscssfile("#{__root_url__}/js/plugins/chartjs/chart.min.js","js")
	loadjscssfile("#{__root_url__}/js/plugins/sparkline/jquery.sparkline.min.js","js")
	loadjscssfile("#{__root_url__}/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js","js")
	###
	
	
Template.main.onCreated ->
	console.log "main.onCreated"
	###
	fileref=document.createElement("link")
	fileref.setAttribute("rel", "stylesheet")
	fileref.setAttribute("type", "text/css")
	fileref.setAttribute("href", "#{CaoLiao.settings.get("Site_Url")}/__cordova/theme.css")
	document.getElementsByTagName("head")[0].appendChild(fileref)
	###


loadjscssfile = (filename, filetype)->
	# console.log filename
	if filetype=="js"
		fileref=document.createElement('script')
		fileref.setAttribute("type","text/javascript")
		fileref.setAttribute("src", filename)
	else if filetype=="css"
		fileref=document.createElement("link")
		fileref.setAttribute("rel", "stylesheet")
		fileref.setAttribute("type", "text/css")
		fileref.setAttribute("href", filename)
	if (typeof fileref)? && document.getElementById("jscssloaded")?
		document.getElementById("jscssloaded").appendChild(fileref)
